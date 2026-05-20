within TrainingBuilding_upd;
package TestBenches
  model TestBench_pump
    Movers.Pump_model2 pump_model2(m_flow_nominal=13,     redeclare package
        Medium = MediumWater)
      annotation (Placement(transformation(extent={{-28,12},{6,48}})));
    Buildings.Fluid.Sources.MassFlowSource_T boundary(
      redeclare package Medium = MediumWater,
      m_flow=m_flow,
      nPorts=1) annotation (Placement(transformation(extent={{-88,10},{-68,30}})));
    Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
          MediumWater, nPorts=1)
      annotation (Placement(transformation(extent={{68,6},{48,26}})));
    Modelica.Blocks.Sources.Constant const(k=10)
      annotation (Placement(transformation(extent={{-62,64},{-42,84}})));
    replaceable package MediumWater = Buildings.Media.Water constrainedby
      Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
    parameter Modelica.Units.SI.MassFlowRate m_flow=10
      "Fixed mass flow rate going out of the fluid port";
  equation
    connect(const.y, pump_model2.m_flow_in) annotation (Line(points={{-41,74},{-14,
            74},{-14,51.6},{-11,51.6}}, color={0,0,127}));
    connect(boundary.ports[1], pump_model2.port_a) annotation (Line(points={{-68,20},
            {-34,20},{-34,30},{-28,30}}, color={0,127,255}));
    connect(pump_model2.port_b, bou.ports[1]) annotation (Line(points={{6,30},{42,
            30},{42,16},{48,16}}, color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end TestBench_pump;
end TestBenches;
