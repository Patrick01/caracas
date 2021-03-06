# devtools::check_win_devel()
# devtools::check_rhub() (rhub::check_for_cran())

# reticulate::py_module_available("sympy")
# reticulate::miniconda_update()


# reticulate::conda_remove('r-reticulate')
# reticulate::use_python('/usr/bin/python3')
# reticulate::conda_create('r-reticulate')
# install_sympy(method = "conda")

# global reference to sympy (will be initialized in .onLoad)
pkg_globals <- new.env()
pkg_globals$internal_sympy <- NULL

#' @importFrom reticulate import py_run_string py_module_available
silent_prepare_sympy <- function() {
  if (!is.null(pkg_globals$internal_sympy)) {
    return()
  }
  
  if (reticulate::py_module_available("sympy")) {
    local_sympy <- reticulate::import("sympy")
    
    if (base::numeric_version(local_sympy$`__version__`) >= "1.4") {
      # All okay:
      
      pkg_globals$internal_sympy <- local_sympy # update global reference
      
      reticulate::py_run_string("from sympy import *")
      #reticulate::py_run_string("from sympy.parsing.sympy_parser import parse_expr")
    } 
    
    # else handled in .onAttach()
  }
}

ensure_sympy <- function() {
  silent_prepare_sympy()
  
  if (is.null(pkg_globals$internal_sympy)) {
    stop("'SymPy' >= 1.4 not available.\n", 
         "Please run this command:\n", 
         "caracas::install_sympy()")
  }
}

#' Check if 'SymPy' is available
#' 
#' @return `TRUE` if 'SymPy' is available, else `FALSE`
#' 
#' @examples 
#' have_sympy()
#' 
#' @concept sympy
#' 
#' @export
have_sympy <- function() {
  silent_prepare_sympy()
  
  return(!is.null(pkg_globals$internal_sympy))
}

#' Get 'SymPy' version
#' 
#' @return The version of the 'SymPy' available
#' 
#' @examples 
#' if (have_sympy()) {
#'   sympy_version()
#' }
#' 
#' @concept sympy
#'
#' @importFrom reticulate import
#' @export
sympy_version <- function() {
  ensure_sympy()
  
  sympy_version <- base::numeric_version(pkg_globals$internal_sympy$`__version__`)
  
  return(sympy_version)
}

#' Access 'SymPy' directly
#' 
#' Get the 'SymPy' object.  
#' Note that it gives you extra responsibilities
#' when you choose to access the 'SymPy' object directly.
#'
#' @return The 'SymPy' object with direct access to the library.
#'
#' @examples 
#' if (have_sympy()) {
#'   sympy <- get_sympy()
#'   sympy$solve("x**2-1", "x")
#' }
#' 
#' @concept sympy
#' 
#' @export
get_sympy <- function() {
  ensure_sympy()
  
  return(pkg_globals$internal_sympy)
}

#' Install 'SymPy'
#' 
#' Install the 'SymPy' Python package into a 
#' virtual environment or Conda environment.
#' 
#' @param method Installation method. 
#' By default, "auto" automatically finds a method that will work 
#' in the local environment. 
#' Change the default to force a specific installation method. 
#' Note that the "virtualenv" method is not available on Windows.
#' @param conda Path to conda executable (or "auto" to find conda 
#' using the PATH and other conventional install locations).
#' 
#' @return None
#' 
#' @concept sympy
#' 
#' @importFrom reticulate py_install
#' @export
install_sympy <- function(method = "auto", conda = "auto") {
  reticulate::py_install("sympy", method = method, conda = conda)
  message("Please check output above to verify that 'SymPy' was installed correctly. ", 
          "If so, please have fun!", 
          "\n\nIf for some reason it does not work, try updating conda\n", 
          "with this R command:\nreticulate::miniconda_update()")
  return(invisible(NULL))
}
