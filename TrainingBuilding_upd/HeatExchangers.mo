within TrainingBuilding_upd;
package HeatExchangers
  model HEX_wer
    extends Buildings.Fluid.HeatExchangers.WetCoilCounterFlow(redeclare package Medium1 = Buildings.Media.Water "Water");
  equation

  end HEX_wer;

  model CoolingCoil
    extends Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU;
  equation

  end CoolingCoil;

  model WetCoilEffectivenessNTUMassFlow
    "Model that tests the wet coil effectiveness-NTU model with variable mass flow rates"
    extends Modelica.Icons.Example;
    extends
      Buildings.Fluid.HeatExchangers.Examples.BaseClasses.EffectivenessNTUMassFlow(
      sou_1(nPorts=1),
      sin_1(nPorts=1),
      sou_2(nPorts=1),
      sin_2(nPorts=1));

    HEX_wer                                                hex(
      redeclare package Medium1 = Medium1,
      redeclare package Medium2 = Medium2,
      m1_flow_nominal=m1_flow_nominal,
      m2_flow_nominal=m2_flow_nominal,
      dp2_nominal(displayUnit="Pa") = 200,
      dp1_nominal(displayUnit="Pa") = 3000,
      UA_nominal=Q_flow_nominal/Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal),
      show_T=true,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
      "Heat exchanger"
      annotation (Placement(transformation(origin = {-12, 18}, extent = {{80, 20}, {100, 40}})));

    Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(redeclare
        package Medium = Medium2, m_flow_nominal=m2_flow_nominal)
      "Relative humidity sensor"
      annotation (Placement(transformation(origin = {-14, 0}, extent = {{60, 14}, {40, 34}})));
    Buildings.Fluid.Sensors.RelativeHumidity senRelHum_inlet(redeclare
        package Medium = Buildings.Media.Air "Moist air")                                                             annotation(
      Placement(transformation(origin = {106, 22}, extent = {{-10, -10}, {10, 10}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package
        Medium = Buildings.Media.Air "Moist air")                                                              annotation(
      Placement(transformation(origin = {62, 24}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
    Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package
        Medium = Buildings.Media.Air "Moist air")                                                               annotation(
      Placement(transformation(origin = {92, 12}, extent = {{10, -10}, {-10, 10}})));
  equation
    connect(sou_1.ports[1], hex.port_a1) annotation(
      Line(points = {{18, 62}, {43, 62}, {43, 54}, {68, 54}}, color = {0, 127, 255}));
    connect(hex.port_b1, sin_1.ports[1]) annotation(
      Line(points = {{88, 54}, {104, 54}, {104, 60}, {120, 60}}, color = {0, 127, 255}));
    connect(senRelHum.port_b, sin_2.ports[1]) annotation(
      Line(points = {{26, 24}, {20, 24}}, color = {0, 127, 255}));
    connect(senRelHum_inlet.port, sou_2.ports[1]) annotation(
      Line(points = {{106, 12}, {120, 12}, {120, 24}, {118, 24}}, color = {0, 127, 255}));
    connect(
        hex.port_b2, senTem.port_a) annotation (
      Line(points = {{68, 42}, {72, 42}, {72, 24}}, color = {0, 127, 255}));
    connect(
        senTem.port_b, senRelHum.port_a) annotation (
      Line(points = {{52, 24}, {46, 24}}, color = {0, 127, 255}));
    connect(
        senTem1.port_a, senRelHum_inlet.port) annotation (
      Line(points = {{102, 12}, {106, 12}}, color = {0, 127, 255}));
    connect(
        hex.port_a2, senTem1.port_b) annotation (
      Line(points = {{88, 42}, {82, 42}, {82, 12}}, color = {0, 127, 255}));
    annotation (
      experiment(Tolerance = 1e-06, StopTime = 3600, StartTime = 0, Interval = 7.2),
      __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/WetCoilEffectivenessNTUMassFlow.mos"
        "Simulate and plot"),
      Diagram(coordinateSystem(preserveAspectRatio=true,
        extent={{-100, -100},{200,200}})),
      Documentation(revisions="<html>
<ul>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation.
</li>
</ul>
</html>",   info="<html>
<p>
This example is similar to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Examples.DryCoilEffectivenessNTUMassFlow\">
Buildings.Fluid.HeatExchangers.Examples.DryCoilEffectivenessNTUMassFlow</a>
except that the coil model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU</a>
is replaced here by
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU</a>.
</p>
</html>"),
      __OpenModelica_simulationFlags(
        lv="LOG_STDOUT,LOG_ASSERT,LOG_STATS",
        s="dassl",
        variableFilter=".*"));
  end WetCoilEffectivenessNTUMassFlow;

  model Experiment_HX
    CoolingCoil coolingCoil(redeclare package Medium1 = MediumW, redeclare
        package Medium2 = MediumA,
      m1_flow_nominal=mwat_nom,
      m2_flow_nominal=mair_nom,
      dp1_nominal=100,
      dp2_nominal=100,
      UA_nominal=10000, energyDynamics = Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
      annotation (Placement(transformation(origin = {10, 6}, extent = {{-32, 10}, {0, 42}})));
    Buildings.Fluid.Sources.Boundary_pT bou(
      p=100000,
      redeclare package Medium = MediumW,
      nPorts=1)
      annotation (Placement(transformation(origin = {8, 0}, extent = {{80, 44}, {60, 64}})));
    Buildings.Fluid.Sources.MassFlowSource_T boundary(
      redeclare package Medium = MediumW,
      m_flow=mwat_nom,
      T=283.15,
      nPorts=1) annotation (Placement(transformation(origin = {2, 0}, extent = {{-86, 54}, {-66, 74}})));
    replaceable package MediumW =Buildings.Media.Water "Water"  annotation (choicesAllMatching=true);
    replaceable package MediumA = Buildings.Media.Air "Moist air"  annotation (choicesAllMatching=true);
    parameter Modelica.Units.SI.MassFlowRate mwat_nom= 10;
     parameter Modelica.Units.SI.MassFlowRate mair_nom= 10;
    Buildings.Fluid.Sources.Boundary_pT bou1(
      p=100000,
      redeclare package Medium = MediumA,
      nPorts=1)
      annotation (Placement(transformation(origin = {4, 16}, extent = {{-96, -38}, {-76, -18}})));
    Buildings.Fluid.Sources.MassFlowSource_T boundary1(
      redeclare package Medium = MediumA,
      use_Xi_in=true,
      T=288.15,
      nPorts=1, m_flow = mair_nom) annotation (Placement(transformation(extent={{76,-14},
              {56,6}})));
    Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum1(redeclare package Medium = MediumA, m_flow_nominal = 10)
      annotation (Placement(transformation(extent={{34,-14},{14,6}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort senTemAir(redeclare package Medium = MediumA, m_flow_nominal = 10)
      annotation (Placement(transformation(origin = {-106, -46}, extent = {{62, -6}, {42, 14}})));
    Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum2(redeclare package Medium = MediumA, m_flow_nominal = 10)
      annotation (Placement(transformation(origin={16,0},     extent = {{-48, -6}, {-68, 14}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort senTemWater(redeclare package Medium = MediumW, m_flow_nominal = 10)
      annotation (Placement(transformation(origin = {20, 0}, extent = {{14, 36}, {34, 56}})));
    Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
      annotation (Placement(transformation(extent={{44,-64},{64,-44}})));
    Modelica.Blocks.Sources.Constant const(k=15 + 273)
      annotation (Placement(transformation(extent={{-10,-42},{10,-22}})));
    Modelica.Blocks.Sources.Constant Humidity(k=0.7)
      annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  equation
    connect(boundary.ports[1], coolingCoil.port_a1) annotation (Line(points={{-64,64},
            {-34,64},{-34,42},{-22,42}},     color={0,127,255}));
    connect(senRelHum1.port_b, coolingCoil.port_a2) annotation (Line(points={
            {14,-4},{6,-4},{6,22},{10,22}}, color={0,127,255}));
    connect(senRelHum2.port_a, coolingCoil.port_b2) annotation (Line(points={{-32,4},
            {-32,9},{-22,9},{-22,22.4}},         color={0,127,255}));
    connect(coolingCoil.port_b1, senTemWater.port_a) annotation (Line(points={{10,
            42},{12,42},{12,46},{34,46}}, color={0,127,255}));
    connect(senTemWater.port_b, bou.ports[1]) annotation (Line(points={{
            54,46},{54,54},{68,54}}, color={0,127,255}));
    connect(
        boundary1.ports[1], senRelHum1.port_a) annotation (
      Line(points={{56,-4},{34,-4}},                  color = {0, 127, 255}));
    connect(
        senTemAir.port_a, senRelHum2.port_b) annotation (
      Line(points={{-44,-42},{-44,4},{-52,4}},
                                            color = {0, 127, 255}));
    connect(
        senTemAir.port_b, bou1.ports[1]) annotation (
      Line(points = {{-64, -42}, {-73, -42}, {-73, -12}, {-72, -12}}, color = {0, 127, 255}));
    connect(const.y, x_pTphi.T) annotation (Line(points={{11,-32},{34,-32},{
            34,-54},{42,-54}}, color={0,0,127}));
    connect(Humidity.y, x_pTphi.phi) annotation (Line(points={{11,-70},{34,
            -70},{34,-60},{42,-60}}, color={0,0,127}));
    connect(x_pTphi.X, boundary1.Xi_in) annotation (Line(points={{65,-54},{88,
            -54},{88,-8},{78,-8}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Experiment_HX;
end HeatExchangers;
