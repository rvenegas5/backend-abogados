const _ = require("lodash");
const { validationResult } = require("express-validator");

const reducer = (accumulator, currentValue) => {
  accumulator[currentValue.param] = accumulator[currentValue.param] || [];
  accumulator[currentValue.param].push(currentValue.msg);
  return accumulator;
};

module.exports.AsyncWrapper = (fn) => {
  return (req, res, next) => {
    return Promise.resolve(fn(req, res, next)).catch((err) => {
      if (_.has(err, ["errors"])) {
        const { errors } = err;

        const formatedErrors = errors.reduce(reducer, {});

        return res.status(422).json(formatedErrors);
      }
      return next(err);
    });
  };
};

module.exports.validateRequest = (req) => {
  return new Promise((resolve, reject) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      // eslint-disable-next-line prefer-promise-reject-errors
      return reject({ errors: errors.array() });
    }
    return resolve();
  });
};
