#pragma once

#include <RcppArmadillo.h>
#include <functional>

struct reaction {
    uint order;
    std::function<double(const arma::vec&)> propensity;
    std::function<void(arma::vec&)> update;
};

class rnet {
public:
    std::vector<std::string> species;
    std::vector<reaction> reactions;
};
