/**
 * Long descriptions for all eco-actions.
 *
 * Each entry has en/ja/es keys with 3-5 sentence
 * markdown descriptions including bold CO2 figures
 * and source links.
 *
 * Split into category files for maintainability,
 * merged here for the seed script.
 */

/* eslint-disable max-len */

const recyclingTransportFood =
  require('./action_descriptions_recyc_trans_food.js');
const energyWater =
  require('./action_descriptions_energy_water.js');
const consumption =
  require('./action_descriptions_consumption.js');
const communityAdvocacyLearning =
  require('./action_descriptions_comm_advo_learn.js');

const allDescriptions = {
  ...recyclingTransportFood,
  ...energyWater,
  ...consumption,
  ...communityAdvocacyLearning,
};

module.exports = allDescriptions;
