within TrainingBuilding_upd;
package Basics

  model Rock "This is a model of a rock in air stream"
    // Parameters
        parameter Real r(unit="m")=0.1     "Radius of rock";
        parameter Real rho(unit="kg/m3")=2230     "Density of rock";
        parameter Real c(unit="J/(kg.K)")=880     "Specific heat capacity of rock";
        parameter Real h(unit="W/(m2.K)")=1000     "Heat transfer coefficient";
        parameter Real T_a(unit="K")=273.15 + 10     "Temperature of air stream";
        parameter Real T_0(unit="K")=273.15 + 20     "Initial temperature of rock";
        parameter Real V(unit="m3")=4/3*3.14*r^3     "Volume of rock";
    parameter Real A(unit="m2")=4*3.14*r^2     "Surface area of rock";
     // Variables
    Real T(unit = "K", start = T_0) "Temperature of rock";
    Real hA "overall ht coefficient";

    parameter Real newVariable=10;
  initial equation
      rho*V*c= hA*(T_a - T);

  algorithm
    //hA:=h*A;
  equation
       rho*V*c= hA*(T_a - T);
    //hA=5*T;
       rho*V*c*der(T) = hA*(T_a - T);

  annotation(
          experiment(StartTime = 0, StopTime = 6000, Tolerance = 1e-06, Interval = 12),
          __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
      Documentation(info="<html>
<p>This is a rock model with air cooling</p>
</html>"));
  end Rock;

  model Resistances
    Modelica.Thermal.HeatTransfer.Components.ThermalResistor R1(R=0.1)
                                                                      annotation(
      Placement(transformation(origin={20,10},    extent = {{-10, -10}, {10, 10}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalResistor R2(R=0.05)
                                                                       annotation(
      Placement(transformation(origin = {-22, 10}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rout(R=0.01)
                                                                         annotation(
      Placement(transformation(origin = {60, 12}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalResistor Rin(R=0.02)
                                                                        annotation(
      Placement(transformation(origin={-64,-34},   extent = {{-10, -10}, {10, 10}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C1(C=1e4)
                                                                    annotation(
      Placement(transformation(origin = {-44, 42}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C2(C=1e5)
                                                                    annotation(
      Placement(transformation(origin = {-6, 40}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor CIn(C=1e3)
                                                                     annotation(
      Placement(transformation(origin={-80,64},    extent = {{-10, -10}, {10, 10}})));
    Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
      prescribedTemperature annotation (
      Placement(transformation(origin={68,-56},    extent = {{10, -10}, {-10, 10}}, rotation = -0)));
    Modelica.Blocks.Interfaces.RealInput T1
      annotation (Placement(transformation(extent={{138,38},{98,78}})));
    parameter Real Globalvar=10;
  equation
    connect(
        Rin.port_a, CIn.port) annotation (
      Line(points={{-74,-34},{-80,-34},{-80,54}},      color = {191, 0, 0}));
    connect(
        Rin.port_b, C1.port) annotation (
      Line(points={{-54,-34},{-44,-34},{-44,32}},      color = {191, 0, 0}));
    connect(
        R2.port_a, C1.port) annotation (
      Line(points = {{-32, 10}, {-44, 10}, {-44, 32}}, color = {191, 0, 0}));
    connect(
        R2.port_b, C2.port) annotation (
      Line(points = {{-12, 10}, {-6, 10}, {-6, 30}}, color = {191, 0, 0}));
    connect(
        R1.port_a, C2.port) annotation (
      Line(points={{10,10},{-6,10},{-6,30}},        color = {191, 0, 0}));
    connect(
        R1.port_b, Rout.port_a) annotation (
      Line(points={{30,10},{40,10},{40,12},{50,12}},
                                          color = {191, 0, 0}));
    connect(
        prescribedTemperature.port, Rout.port_b) annotation (
      Line(points={{58,-56},{54,-56},{54,-2},{74,-2},{74,12},{70,12}},
                                           color = {191, 0, 0}));
    connect(prescribedTemperature.T, T1) annotation (Line(points={{80,-56},{
            92,-56},{92,58},{118,58}}, color={0,0,127}));
  annotation(
      experiment(
        StopTime=86400,
        Interval=172.8,
        Tolerance=1e-06,
        __Dymola_Algorithm="Dassl"),
      __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
  end Resistances;

  model RockModified "This is a model of a rock in air stream"
        parameter Real r(unit="m")=0.1     "Radius of rock";
        parameter Real rho(unit="kg/m3")=2230     "Density of rock";
        parameter Real c(unit="J/(kg.K)")=880     "Specific heat capacity of rock";
        parameter Real h(unit="W/(m2.K)")=1000     "Heat transfer coefficient";
        parameter Real T_a(unit="K")=273.15 + 10     "Temperature of air stream";
        parameter Real T_0(unit="K")=273.15 + 20     "Initial temperature of rock";
        parameter Real V(unit="m3")=4/3*3.14*r^3     "Volume of rock";
        parameter Real A(unit="m2")=4*3.14*r^2     "Surface area of rock";
    // Real T(unit = "K", start = T_0) "Temperature of rock";
        Real T(unit = "K") "Temperature of rock";

  initial equation
    //T= (T_a+T_0)/2;
  equation
        rho*V*c*der(T) = h*A*(T_a - T);
        annotation(
          experiment(StartTime = 0, StopTime = 6000, Tolerance = 1e-06, Interval = 12),
          __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"));
  end RockModified;
end Basics;
