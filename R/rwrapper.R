# Search the package x.
# If x is already installed then x is loaded
# else it is downloaded and setup.
pkg.R.install <- function(x) {
    libraries <- library()
    lib.names <- libraries$result[, 1]
    if (!(x %in% lib.names)) {
        install.packages(x)
    }
    library(x, character.only = TRUE)
}

# If Julia package x is already installed 
# do nothing, else download and install it.
pkg.julia.install <- function(x){
    result <- julia_installed_package(pkg_name = x)
    if (result == "nothing") {
        log_info("Installing required packages")
        julia_install_package(pkg_name_or_url = x)
    }
}

# Checking if the logger package is already installed.
cat("* Checking package logger\n")
pkg.R.install("logger")

# Setting up the Julia Environment
log_info("Checking JuliaCall")
pkg.R.install("JuliaCall")
julia_setup(installJulia = TRUE)


# Setting up the JMcDM package
log_info("Checking JMcDM")
julia_library("JMcDM")

# Registering Julia and JMcDM functions
# onto the R environment
log_info("Registering Julia function makeminmax()")
makeminmax <- julia_function("makeminmax")

log_info("Registering Julia function topsis()")
topsis <- julia_function("topsis")

log_info("Registering Julia function electre()")
electre <- julia_function("electre")

log_info("Registering Julia function moora()")
moora <- julia_function("moora")

log_info("Registering Julia function vikor()")
vikor <- julia_function("vikor")

log_info("Registering Julia function aras()")
aras <- julia_function("aras")

log_info("Registering Julia function cocoso()")
cocoso <- julia_function("cocoso")

log_info("Registering Julia function codas()")
codas <- julia_function("codas")

log_info("Registering Julia function copras()")
copras <- julia_function("copras")

log_info("Registering Julia function critic()")
critic <- julia_function("critic")

log_info("Registering Julia function dataenvelop()")
dataenvelop <- julia_function("dataenvelop")

log_info("Registering Julia function dematel()")
dematel <- julia_function("dematel")

log_info("Registering Julia function edas()")
edas <- julia_function("edas")

log_info("Registering Julia function entropy()")
entropy <- julia_function("entropy")

log_info("Registering Julia function grey()")
grey <- julia_function("grey")

log_info("Registering Julia function mabac()")
mabac <- julia_function("mabac")

log_info("Registering Julia function mairca()")
mairca <- julia_function("mairca")

log_info("Registering Julia function marcos()")
marcos <- julia_function("marcos")

log_info("Registering Julia function nds()")
nds <- julia_function("nds")

log_info("Registering Julia function saw()")
saw <- julia_function("saw")

log_info("Registering Julia function waspas()")
waspas <- julia_function("waspas")

log_info("Registering Julia function wpm()")
wpm <- julia_function("wpm")


# Sample usage of Topsis
log_info("Generating sample decision matrix: df")
df <- data.frame(
    x = c(1.0, 2, 5, 6),
    y = c(2.0, 5.0, 10.0, 7.0),
    z = c(4.0, 2.0, 1.0, 2.0)
)
w <- c(0.5, 0.25, 0.25)
fns <- makeminmax(c(max, max, min))
print(df)
tresult <- topsis(df, w, fns)
print(tresult$scores)



