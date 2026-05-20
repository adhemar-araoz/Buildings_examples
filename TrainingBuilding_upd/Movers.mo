within TrainingBuilding_upd;
package Movers "Extended Movers BL"
  model Pump_1
    extends Buildings.Fluid.Movers.FlowControlled_m_flow(
      m_flow_nominal=0.9,                                                       use_riseTime = false, redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per, energyDynamics = Modelica.Fluid.Types.Dynamics.DynamicFreeInitial, redeclare package Medium = Buildings.Media.Water "Water");
  end Pump_1;

  model Pump_model2
    extends Buildings.Fluid.Movers.FlowControlled_m_flow(
      m_flow_nominal=4,                                                         use_riseTime = false,
      redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.TopS40slash10 per(
          motorEfficiency=0.6, motorEfficiency_yMot=0.9),                                                                                                                      energyDynamics = Modelica.Fluid.Types.Dynamics.DynamicFreeInitial, redeclare package Medium = Buildings.Media.Water "Water");
  end Pump_model2;
end Movers;
