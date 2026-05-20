within TrainingBuilding_upd;
package Examples
  model SimpleCircuit
    Movers.Pump_1 pump_1_1(     redeclare package Medium = Medium) annotation(
      Placement(transformation(origin={18,-2},    extent = {{-18, 28}, {2, 48}})));
    Buildings.Fluid.FixedResistances.PressureDrop res(redeclare package Medium = Medium, m_flow_nominal = 0.86, dp_nominal = 13150/2) annotation(
      Placement(transformation(origin = {66, -52}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium) annotation(
      Placement(transformation(origin={-4,24},     extent = {{-88, -6}, {-68, 14}})));
    replaceable package Medium = Buildings.Media.Water constrainedby Modelica.Media.Interfaces.PartialMedium annotation(
       choicesAllMatching = true);
    Modelica.Blocks.Sources.Ramp ramp(height = 0.86, duration = 60, offset = 0.30, startTime = 50) annotation(
      Placement(transformation(                  extent={{-66,60},{-46,80}})));
    Modelica.Blocks.Sources.Constant const(k = 0.86) annotation(
      Placement(transformation(origin={30,26},    extent = {{-66, 34}, {-46, 54}})));
    Buildings.Fluid.FixedResistances.PressureDrop res1(redeclare package Medium = Medium, dp_nominal = 13150/2, m_flow_nominal = 0.86) annotation(
      Placement(transformation(origin={-36,28},    extent = {{-10, -10}, {10, 10}})));
  equation
    connect(const.y, pump_1_1.m_flow_in)
      annotation (Line(points={{-15,70},{10,70},{10,48}}, color={0,0,127}));
    connect(res.port_b, exp.port_a) annotation(
      Line(points={{66,-62},{66,-66},{-82,-66},{-82,18}},color = {0, 127, 255}));
    connect(exp.port_a, res1.port_a) annotation(
      Line(points={{-82,18},{-82,14},{-56,14},{-56,28},{-46,28}},
                                                         color = {0, 127, 255}));
    connect(res1.port_b, pump_1_1.port_a) annotation (Line(points={{-26,28},{
            -6,28},{-6,36},{0,36}}, color={0,127,255}));
    connect(res.port_a, pump_1_1.port_b) annotation (Line(points={{66,-42},{
            66,36},{20,36}}, color={0,127,255}));
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false)),
      Diagram(coordinateSystem(preserveAspectRatio = false)),
      __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_NLS_V,LOG_NLS_SVD,LOG_NLS_RES,LOG_STATS", s = "dassl", variableFilter = ".*"),
      experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.2),
      Documentation(info="<html>
<p>Example of a Simple Circuit</p>
</html>"));
  end SimpleCircuit;

  model SimpleCircuit_2
    Movers.Pump_1 pump_1(redeclare package Medium = Medium) annotation(
      Placement(transformation(origin = {6, -2}, extent = {{-18, 28}, {2, 48}})));
    Buildings.Fluid.FixedResistances.PressureDrop res(redeclare package Medium = Medium, m_flow_nominal = 0.86, dp_nominal = 13150/3) annotation(
      Placement(transformation(origin = {54, -16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium) annotation(
      Placement(transformation(origin = {6, 6}, extent = {{-88, -6}, {-68, 14}})));
    replaceable package Medium = Buildings.Media.Water constrainedby Modelica.Media.Interfaces.PartialMedium annotation(
       choicesAllMatching = true);
    Modelica.Blocks.Sources.Ramp ramp(height = 0.86, duration = 60, offset = 0.30, startTime = 50) annotation(
      Placement(transformation(extent = {{-66, 66}, {-46, 86}})));
    Modelica.Blocks.Sources.Constant const(k = 0.86) annotation(
      Placement(transformation(origin = {0, 2}, extent = {{-66, 34}, {-46, 54}})));
    Buildings.Fluid.FixedResistances.PressureDrop res1(redeclare package Medium = Medium, dp_nominal = 13150/3, m_flow_nominal = 0.86, from_dp = true) annotation(
      Placement(transformation(origin={-28,-72},   extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Buildings.Fluid.FixedResistances.Junction jun
      annotation (Placement(transformation(extent={{-12,-42},{8,-22}})));
  equation
    connect(pump_1.port_b, res.port_a) annotation(
      Line(points = {{8, 36}, {54, 36}, {54, -6}}, color = {0, 127, 255}));
    connect(exp.port_a, pump_1.port_a) annotation(
      Line(points = {{-72, 0}, {-72, -10}, {-24, -10}, {-24, 36}, {-12, 36}}, color = {0, 127, 255}));
    connect(res1.port_a, res.port_b) annotation(
      Line(points={{-18,-72},{54,-72},{54,-26}},                                                                       color = {0, 127, 255}));
    connect(const.y, pump_1.m_flow_in) annotation(
      Line(points = {{-45, 46}, {-23.5, 46}, {-23.5, 48}, {-2, 48}}, color = {0, 0, 127}));
    connect(
        res1.port_b, exp.port_a) annotation (
      Line(points={{-38,-72},{-72,-72},{-72,0}},        color = {0, 127, 255}));
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false)),
      Diagram(coordinateSystem(preserveAspectRatio = false)),
      __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_NLS_V,LOG_NLS_SVD,LOG_NLS_RES,LOG_STATS", s = "dassl", variableFilter = ".*"),
      experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.2));
  end SimpleCircuit_2;

  model SimpleCircuit_3
    Movers.Pump_1 pump_1(redeclare package Medium = Medium) annotation(
      Placement(transformation(origin = {10, -26}, extent = {{-18, 28}, {2, 48}})));
    Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium, V_start = 0.1) annotation(
      Placement(transformation(origin = {8, 12}, extent = {{-88, -6}, {-68, 14}})));
    replaceable package Medium = Buildings.Media.Water constrainedby Modelica.Media.Interfaces.PartialMedium annotation(
       choicesAllMatching = true);
    Modelica.Blocks.Sources.Ramp ramp(height = 0.86, duration = 60, offset = 0.30, startTime = 50) annotation(
      Placement(transformation(origin = {0, 2}, extent = {{-66, 66}, {-46, 86}})));
    Modelica.Blocks.Sources.Constant const(k = 0.86) annotation(
      Placement(transformation(origin = {0, 2}, extent = {{-66, 34}, {-46, 54}})));
    Buildings.Fluid.MixingVolumes.MixingVolume vol(
      nPorts=2,
      redeclare package Medium = Medium,
      m_flow_nominal=0.8,
      V=0.5,
      T_start=303.15,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)                                                                                                                                             annotation(
      Placement(transformation(origin = {-28, -38}, extent = {{-10, -10}, {10, 10}})));
    Buildings.Fluid.MixingVolumes.MixingVolume vol1(
      redeclare package Medium = Medium,
      V=0.5,
      m_flow_nominal=30,
      nPorts=2,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=353.15)                                                                                                                                                                                                         annotation(
      Placement(transformation(origin = {64, -38}, extent = {{-10, -10}, {10, 10}})));
    Buildings.HeatTransfer.Sources.FixedHeatFlow preHeaFlo2(Q_flow=10000)
                                                                        annotation(
      Placement(transformation(origin = {20, -80}, extent = {{-10, -10}, {10, 10}})));
    Buildings.HeatTransfer.Sources.FixedTemperature preTem(T=303.15)
                                                                    annotation(
      Placement(transformation(origin = {-56, -74}, extent = {{-10, -10}, {10, 10}})));
    Buildings.Fluid.FixedResistances.PressureDrop res(
      redeclare package Medium = Medium,
      dp_nominal=13150/3,
      m_flow_nominal=0.86)                                                                                                        annotation(
      Placement(transformation(origin = {66, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  equation
    connect(exp.port_a, pump_1.port_a) annotation(
      Line(points = {{-70, 6}, {-70, -10}, {-24, -10}, {-24, 12}, {-8, 12}}, color = {0, 127, 255}));
    connect(const.y, pump_1.m_flow_in) annotation(
      Line(points = {{-45, 46}, {-25.5, 46}, {-25.5, 24}, {2, 24}}, color = {0, 0, 127}));
    connect(exp.port_a, vol.ports[1]) annotation(
      Line(points = {{-70, 6}, {-71, 6}, {-71, -32}, {-82, -32}, {-82, -48}, {-28, -48}}, color = {0, 127, 255}));
    connect(
        vol1.ports[1], vol.ports[2]) annotation (
      Line(points = {{64, -48}, {-28, -48}}, color = {0, 127, 255}));
    connect(
        preHeaFlo2.port, vol1.heatPort) annotation (
      Line(points = {{30, -80}, {54, -80}, {54, -38}}, color = {191, 0, 0}));
    connect(
        preTem.port, vol.heatPort) annotation (
      Line(points = {{-46, -74}, {-38, -74}, {-38, -38}}, color = {191, 0, 0}));
    connect(
        pump_1.port_b, res.port_a) annotation (
      Line(points = {{12, 12}, {39, 12}, {39, 10}, {66, 10}}, color = {0, 127, 255}));
    connect(
        vol1.ports[2], res.port_b) annotation (
      Line(points = {{64, -48}, {66, -48}, {66, -10}}, color = {0, 127, 255}));
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false)),
      Diagram(coordinateSystem(preserveAspectRatio = false)),
      __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
      experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.2));
  end SimpleCircuit_3;

  model SimpleCircuit_ideal
    Buildings.Fluid.FixedResistances.PressureDrop res(redeclare package Medium = Medium, m_flow_nominal = 0.86, dp_nominal = 13150/2) annotation(
      Placement(transformation(origin = {66, -52}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package Medium = Medium) annotation(
      Placement(transformation(origin={-4,24},     extent = {{-88, -6}, {-68, 14}})));
    replaceable package Medium = Buildings.Media.Water constrainedby Modelica.Media.Interfaces.PartialMedium annotation(
       choicesAllMatching = true);
    Modelica.Blocks.Sources.Ramp ramp(height = 0.86, duration = 60, offset = 0.30, startTime = 50) annotation(
      Placement(transformation(                  extent={{-66,60},{-46,80}})));
    Modelica.Blocks.Sources.Constant const(k = 0.86) annotation(
      Placement(transformation(origin={30,26},    extent = {{-66, 34}, {-46, 54}})));
    Buildings.Fluid.FixedResistances.PressureDrop res1(redeclare package Medium = Medium, dp_nominal = 13150/2, m_flow_nominal = 0.86) annotation(
      Placement(transformation(origin={-40,20},    extent = {{-10, -10}, {10, 10}})));
    Buildings.Fluid.Sources.MassFlowSource_T boundary(
      m_flow=0.8,
      nPorts=2,
      redeclare package Medium = Medium)
      annotation (Placement(transformation(extent={{6,36},{26,56}})));
  equation
    connect(res.port_b, exp.port_a) annotation(
      Line(points={{66,-62},{66,-66},{-82,-66},{-82,18}},color = {0, 127, 255}));
    connect(exp.port_a, res1.port_a) annotation(
      Line(points={{-82,18},{-82,14},{-56,14},{-56,20},{-50,20}},
                                                         color = {0, 127, 255}));
    connect(boundary.ports[1], res.port_a) annotation (Line(points={{26,45},{
            66,45},{66,-42}}, color={0,127,255}));
    connect(res1.port_b, boundary.ports[2]) annotation (Line(points={{-30,20},
            {26,20},{26,47}}, color={0,127,255}));
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false)),
      Diagram(coordinateSystem(preserveAspectRatio = false)),
      __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_NLS_V,LOG_NLS_SVD,LOG_NLS_RES,LOG_STATS", s = "dassl", variableFilter = ".*"),
      experiment(StartTime = 0, StopTime = 100, Tolerance = 1e-06, Interval = 0.2),
      Documentation(info="<html>
<p>Example of a Simple Circuit</p>
</html>"));
  end SimpleCircuit_ideal;
end Examples;
