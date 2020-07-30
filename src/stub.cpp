#include <RcppArmadillo.h>
#include <rnet.h>

//[[Rcpp::export()]]
arma::vec propensities_cpp(SEXP rnet_xptr, arma::vec v) {
    auto net = *Rcpp::XPtr<bondr::rnet>(rnet_xptr);
    
    arma::vec p = arma::vec(net.reactions.size());
    for (uint i = 0; i < p.size(); i++)
        p[i] = net.reactions[i].propensity(v);

    return p;
}
