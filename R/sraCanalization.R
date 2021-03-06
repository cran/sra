sraCanalization <-
function (sradata, start = NULL, fixed = NULL, macroE = FALSE, 
    Bulmer = TRUE, ...) 
{
    if (!Bulmer) {
        sradata$vsel <- sradata$var
    }
    default.start <- list(mu0 = NA, logvarA0 = NA, logvarE0 = NA, 
        kc = NA, kg = NA)
    default.fixed <- list(logNe = log(1e+10), logvarM = log(1e-20), 
        logn = log(1e+10), o = NA, s = 0)
    if (macroE) {
        default.start$logvarME <- NA
    }
    else {
        default.fixed$logvarME <- log(1e-20)
    }
    default.start[names(fixed)] <- NULL
    default.start[names(start)] <- start
    default.fixed[names(start)] <- NULL
    default.fixed[names(fixed)] <- fixed
    start <- default.start
    fixed <- default.fixed
    start[is.na(start)] <- sapply(names(start[is.na(start)]), 
        sraStartingvalues, sradata = sradata)
    fixed[is.na(fixed)] <- sapply(names(fixed[is.na(fixed)]),
        sraStartingvalues, sradata = sradata)
    mlewrapper <- function(mu0, logvarA0, logvarE0, logNe, logn, 
        logvarM, kc, kg, o, s, logvarME) {
        sraMinuslogL(sradata = sradata, FUNtimeseries = sraTimeseries, 
            mu0 = mu0, logvarA0 = logvarA0, logvarE0 = logvarE0, 
            logNe = logNe, logn = logn, logvarM = logvarM, kc = kc, 
            kg = kg, o = o, s = s, logvarME = logvarME)
    }
    fit <- mle(minuslogl = mlewrapper, start = start, fixed = fixed, 
        ...)
    return(sraMakeObject(sradata = sradata, model = fit, start = start, 
        fixed = fixed, FUNtimeseries = sraTimeseries))
}
