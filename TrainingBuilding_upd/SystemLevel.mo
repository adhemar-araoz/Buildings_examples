within TrainingBuilding_upd;
package SystemLevel
model SpaceCooling
 replaceable package MediumA=Buildings.Media.Air "Medium for Air";
 replaceable package MediumW=Buildings.Media.Water "Medium for water";
  parameter Modelica.Units.SI.Volume V=6*10*3;
 //parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600;
 parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000;
parameter Real eps = 0.8
  "Heat recovery effectiveness";

parameter Modelica.Units.SI.Temperature TRooSet=273.15 + 24
  "Nominal room air temperature";

parameter Modelica.Units.SI.Temperature TASup_nominal=273.15 + 18
  "Nominal air temperature supplied to room";

parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal = 0.012
  "Nominal supply air humidity ratio [kg/kg]";

parameter Modelica.Units.SI.Temperature TOut_nominal=273.15 + 30
  "Design outside air temperature";

parameter Modelica.Units.SI.Temperature THeaRecLvg =
  TOut_nominal - eps*(TOut_nominal - TRooSet)
  "Nominal air temperature leaving the heat recovery";

parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg = 0.0135
  "Nominal air humidity ratio [kg/kg] leaving the heat recovery";

parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal =
  -QRooInt_flow - 10E3/30*(TOut_nominal - TRooSet)
  "Nominal cooling load of the room";

parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal =
  1.3*QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
  "Nominal air mass flow rate";

parameter Modelica.Units.SI.TemperatureDifference dTFan = 2
  "Estimated temperature raise across fan";

parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal =
  mA_flow_nominal*(TASup_nominal - THeaRecLvg - dTFan)*1006
  + mA_flow_nominal*(wASup_nominal - wHeaRecLvg)*2458.3e3
  "Cooling load of coil, including sensible and latent load";

parameter Modelica.Units.SI.Temperature TWSup_nominal=273.15 + 12
  "Water supply temperature";

parameter Modelica.Units.SI.Temperature TWRet_nominal=273.15 + 16
  "Water return temperature";

parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal =
  -QCoiC_flow_nominal/(TWRet_nominal - TWSup_nominal)/4200
  "Nominal water mass flow rate";

Buildings.Fluid.MixingVolumes.MixingVolume vol(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, mSenFac = 3, m_flow_nominal = mA_flow_nominal, V = V, redeclare package Medium = Buildings.Media.Air
        "Moist air",                                                                                                                                                                                                        nPorts = 2)  annotation(
      Placement(transformation(origin = {90, 32}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G = 10000/30)  annotation(
      Placement(transformation(origin = {34, 42}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow = QRooInt_flow)  annotation(
      Placement(transformation(origin = {46, 80}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tout_1 annotation(
      Placement(transformation(origin = {-4, 56}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Movers.FlowControlled_m_flow fan(energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, m_flow_nominal = mA_flow_nominal, redeclare package Medium = Buildings.Media.Air "Moist air", addPowerToMedium = false)  annotation(
      Placement(transformation(origin = {60, -12}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(m1_flow_nominal = mA_flow_nominal, m2_flow_nominal = mA_flow_nominal, dp1_nominal = 200, dp2_nominal = 200, redeclare package Medium1 = Buildings.Media.Air "Moist air", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
      Placement(transformation(origin = {-62, -14}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(m1_flow_nominal = mW_flow_nominal, m2_flow_nominal = mA_flow_nominal, show_T = true, dp1_nominal = 6000, dp2_nominal = 200, use_Q_flow_nominal = true, Q_flow_nominal = QCoiC_flow_nominal, T_a1_nominal = TWSup_nominal, T_a2_nominal = THeaRecLvg, w_a2_nominal = wHeaRecLvg, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, redeclare package Medium1 = Buildings.Media.Water "Water", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
      Placement(transformation(origin = {-2, -10}, extent = {{10, 10}, {-10, -10}})));
Buildings.Fluid.Sources.MassFlowSource_T souWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water", use_m_flow_in = true, T = TWSup_nominal)  annotation(
      Placement(transformation(origin = {-18, -90}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sources.Boundary_pT sinWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water")  annotation(
      Placement(transformation(origin = {-40, -52}, extent = {{-10, -10}, {10, 10}})));
Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam = "C:/Users/jadhe/OneDrive/Documents/Dymola/Buildings 13.0.0/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos", TDryBulSou = Buildings.BoundaryConditions.Types.DataSource.Parameter, TDryBul = TOut_nominal, computeWetBulbTemperature = false)  annotation(
      Placement(transformation(origin={-171,77},   extent = {{-15, -13}, {15, 13}})));
 //  /modelica://Buildings/Resources/weatherdata/USA_IL_ChicagoOHare.Intl.AP.725300_TMY3.mos"
    Buildings.Fluid.Sensors.TemperatureTwoPort senTemHxOut(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {28, -10}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {-28, -3}, extent = {{-8, -9}, {8, 9}})));
Buildings.Controls.OBC.CDL.Reals.Sources.Constant mWat_flow(k = mW_flow_nominal)  annotation(
      Placement(transformation(origin={-88,-78},    extent = {{-10, -10}, {10, 10}})));
Buildings.Controls.OBC.CDL.Reals.Sources.Constant mAir_flow(k = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {-28, 26}, extent = {{-10, -10}, {10, 10}})));
Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation(
      Placement(transformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sources.Outside out(redeclare package Medium = Buildings.Media.Air "Moist air", nPorts = 2)  annotation(
      Placement(transformation(origin={-100,36},   extent = {{-10, -10}, {10, 10}})));
equation
    connect(theCon.port_b, vol.heatPort) annotation(
      Line(points = {{44, 42}, {59, 42}, {59, 32}, {80, 32}}, color = {191, 0, 0}));
    connect(preHea.port, vol.heatPort) annotation(
      Line(points = {{56, 80}, {56, 32}, {80, 32}}, color = {191, 0, 0}));
    connect(Tout_1.port, theCon.port_a) annotation(
      Line(points = {{6, 56}, {6, 42}, {24, 42}}, color = {191, 0, 0}));
    connect(fan.port_a, senTemHxOut.port_b) annotation(
      Line(points = {{50, -12}, {44, -12}, {44, -10}, {38, -10}}, color = {0, 127, 255}));
    connect(fan.port_b, vol.ports[1]) annotation(
      Line(points = {{70, -12}, {90, -12}, {90, 22}}, color = {0, 127, 255}));
    connect(fan.m_flow_in, mAir_flow.y) annotation(
      Line(points = {{60, 0}, {50.75, 0}, {50.75, 6}, {39.5, 6}, {39.5, 18}, {-16, 18}, {-16, 26}}, color = {0, 0, 127}));
    connect(mWat_flow.y, souWat.m_flow_in) annotation(
      Line(points={{-76,-78},{-40,-78},{-40,-82},{-30,-82}},          color = {0, 0, 127}));
    connect(cooCoi.port_a2, senTemSupAir.port_b) annotation(
      Line(points = {{-12, -4}, {-19, -4}, {-19, -3}, {-20, -3}}, color = {0, 127, 255}));
    connect(cooCoi.port_b2, senTemHxOut.port_a) annotation(
      Line(points = {{8, -4}, {13, -4}, {13, -10}, {18, -10}}, color = {0, 127, 255}));
    connect(cooCoi.port_a1, souWat.ports[1]) annotation(
      Line(points = {{8, -16}, {8, -20}, {5.5, -20}, {5.5, -24}, {15, -24}, {15, -76}, {12, -76}, {12, -74}, {-8, -74}, {-8, -90}}, color = {0, 127, 255}));
    connect(cooCoi.port_b1, sinWat.ports[1]) annotation(
      Line(points = {{-12, -16}, {-26, -16}, {-26, -52}, {-30, -52}}, color = {0, 127, 255}));
    connect(weaDat.weaBus, weaBus) annotation(
      Line(points={{-156,77},{-116,77},{-116,68},{-46,68}},
                                                       color = {255, 204, 51}, thickness = 0.5),
      Text(string = "%second", index = 1, extent = {{2, 2}, {2, 5}}, horizontalAlignment = TextAlignment.Left));
    connect(Tout_1.T, weaBus.TDryBul) annotation(
      Line(points = {{-16, 56}, {-32, 56}, {-32, 68.05}, {-45.95, 68.05}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{-2, 2}, {-2, 5}}, horizontalAlignment = TextAlignment.Right));
    connect(hex.port_b1, senTemSupAir.port_a) annotation(
      Line(points={{-52,-8},{-36,-8},{-36,-3}},        color = {0, 127, 255}));
    connect(hex.port_a2, vol.ports[2]) annotation(
      Line(points = {{-52, -20}, {90, -20}, {90, 22}}, color = {0, 127, 255}));
connect(out.ports[1], hex.port_a1) annotation(
      Line(points={{-90,35},{-78,35},{-78,-8},{-72,-8}},          color = {0, 127, 255}));
connect(hex.port_b2, out.ports[2]) annotation(
      Line(points={{-72,-20},{-80,-20},{-80,37},{-90,37}},       color = {0, 127, 255}));
connect(weaDat.weaBus, out.weaBus) annotation(
      Line(points={{-156,77},{-116,77},{-116,36.2},{-110,36.2}},
                                                       color = {255, 204, 51}, thickness = 0.5));
    annotation(
      experiment(StartTime = 0, StopTime = 10800, Tolerance = 1e-06, Interval = 21.6867),
      __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "dassl", variableFilter = ".*"),
      Diagram(coordinateSystem(extent={{-200,-100},{100,100}})),
      Icon(coordinateSystem(extent={{-200,-100},{100,100}})));
end SpaceCooling;

  model RoomModel
  replaceable package MediumA = Buildings.Media.Air "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";
  parameter Modelica.Units.SI.Volume V=6*10*3;
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600;
    parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000;

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)    annotation(
        Placement(transformation(origin={-16,6},    extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      mSenFac=3,
      m_flow_nominal=mA_flow_nominal,
      V=V,
      redeclare package Medium = Buildings.Media.Air "Moist air",
      nPorts=2)                                                                                                                                                                                                         annotation(
        Placement(transformation(origin={42,6},     extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
          QRooInt_flow)                                                              annotation(
        Placement(transformation(origin={-20,42},   extent = {{-10, -10}, {10, 10}})));
    Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T
        =263.15)
      annotation (Placement(transformation(extent={{-72,-6},{-52,14}})));
  equation
    connect(theCon.port_b, vol.heatPort)
      annotation (Line(points={{-6,6},{32,6}}, color={191,0,0}));
    connect(preHea.port, vol.heatPort) annotation (Line(points={{-10,42},{22,
            42},{22,6},{32,6}}, color={191,0,0}));
    connect(fixedTemperature.port, theCon.port_a) annotation (Line(points={{
            -52,4},{-30,4},{-30,6},{-26,6}}, color={191,0,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end RoomModel;

model SpaceCooling_Controlled
 replaceable package MediumA=Buildings.Media.Air "Medium for Air";
 replaceable package MediumW=Buildings.Media.Water "Medium for water";
 parameter Modelica.Units.SI.Volume V=6*10*3;
 //parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600;
 parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000;
parameter Real eps = 0.8
  "Heat recovery effectiveness";

parameter Modelica.Units.SI.Temperature TRooSet=273.15 + 24
  "Nominal room air temperature";

parameter Modelica.Units.SI.Temperature TASup_nominal=273.15 + 18
  "Nominal air temperature supplied to room";

parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal = 0.012
  "Nominal supply air humidity ratio [kg/kg]";

parameter Modelica.Units.SI.Temperature TOut_nominal=273.15 + 30
  "Design outside air temperature";

parameter Modelica.Units.SI.Temperature THeaRecLvg =
  TOut_nominal - eps*(TOut_nominal - TRooSet)
  "Nominal air temperature leaving the heat recovery";

parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg = 0.0135
  "Nominal air humidity ratio [kg/kg] leaving the heat recovery";

parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal =
  -QRooInt_flow - 10E3/30*(TOut_nominal - TRooSet)
  "Nominal cooling load of the room";

parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal =
  1.3*QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
  "Nominal air mass flow rate";

parameter Modelica.Units.SI.TemperatureDifference dTFan = 2
  "Estimated temperature raise across fan";

parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal =
  mA_flow_nominal*(TASup_nominal - THeaRecLvg - dTFan)*1006
  + mA_flow_nominal*(wASup_nominal - wHeaRecLvg)*2458.3e3
  "Cooling load of coil, including sensible and latent load";

parameter Modelica.Units.SI.Temperature TWSup_nominal=273.15 + 12
  "Water supply temperature";

parameter Modelica.Units.SI.Temperature TWRet_nominal=273.15 + 16
  "Water return temperature";

parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal =
  -QCoiC_flow_nominal/(TWRet_nominal - TWSup_nominal)/4200
  "Nominal water mass flow rate";

Buildings.Fluid.MixingVolumes.MixingVolume vol(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, mSenFac = 3, m_flow_nominal = mA_flow_nominal, V = V, redeclare package Medium = Buildings.Media.Air
        "Moist air",                                                                                                                                                                                                        nPorts = 2)  annotation(
      Placement(transformation(origin = {90, 32}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G = 10000/30)  annotation(
      Placement(transformation(origin = {34, 42}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow = QRooInt_flow)  annotation(
      Placement(transformation(origin = {46, 80}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tout_1 annotation(
      Placement(transformation(origin = {-4, 56}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Movers.FlowControlled_m_flow fan(energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, m_flow_nominal = mA_flow_nominal, redeclare package Medium = Buildings.Media.Air "Moist air", addPowerToMedium = false)  annotation(
      Placement(transformation(origin = {60, -12}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(m1_flow_nominal = mA_flow_nominal, m2_flow_nominal = mA_flow_nominal, dp1_nominal = 200, dp2_nominal = 200, redeclare package Medium1 = Buildings.Media.Air "Moist air", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
      Placement(transformation(origin = {-62, -14}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(m1_flow_nominal = mW_flow_nominal, m2_flow_nominal = mA_flow_nominal, show_T = true, dp1_nominal = 6000, dp2_nominal = 200, use_Q_flow_nominal = true, Q_flow_nominal = QCoiC_flow_nominal, T_a1_nominal = TWSup_nominal, T_a2_nominal = THeaRecLvg, w_a2_nominal = wHeaRecLvg, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, redeclare package Medium1 = Buildings.Media.Water "Water", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
      Placement(transformation(origin = {-2, -10}, extent = {{10, 10}, {-10, -10}})));
Buildings.Fluid.Sources.MassFlowSource_T souWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water", use_m_flow_in = true, T = TWSup_nominal)  annotation(
      Placement(transformation(origin = {-18, -90}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sources.Boundary_pT sinWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water")  annotation(
      Placement(transformation(origin = {-40, -52}, extent = {{-10, -10}, {10, 10}})));
Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      filNam=Modelica.Utilities.Files.loadResource(
          "modelica://TrainingBuilding_upd/Resources/SGP_Singapore.486980_IWEC.mos"),
      TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,                                                                                                                                                                                                      TDryBul = TOut_nominal, computeWetBulbTemperature = false)  annotation(
      Placement(transformation(origin={-211,63},   extent = {{-15, -13}, {15, 13}})));
 //  /modelica://Buildings/Resources/weatherdata/USA_IL_ChicagoOHare.Intl.AP.725300_TMY3.mos"
    Buildings.Fluid.Sensors.TemperatureTwoPort senTemHxOut(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {28, -10}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {-28, -3}, extent = {{-8, -9}, {8, 9}})));
Buildings.Controls.OBC.CDL.Reals.Sources.Constant mAir_flow(k = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {-28, 26}, extent = {{-10, -10}, {10, 10}})));
Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation(
      Placement(transformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sources.Outside out(redeclare package Medium = Buildings.Media.Air "Moist air", nPorts = 2)  annotation(
      Placement(transformation(origin={-100,36},   extent = {{-10, -10}, {10, 10}})));
    Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoint(k=297.15)
      annotation (Placement(transformation(origin={-10,-6},   extent = {{-218, -46}, {-198, -26}})));
    Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(uLow=0, uHigh=1)
      annotation (Placement(transformation(extent={{-142,-76},{-122,-56}})));
    Buildings.Controls.OBC.CDL.Reals.Subtract sub
      annotation (Placement(transformation(extent={{-174,-76},{-154,-56}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mWatFlow(realTrue=0,
        realFalse=mW_flow_nominal)
      annotation (Placement(transformation(extent={{-102,-80},{-82,-60}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
      annotation (Placement(transformation(extent={{106,60},{126,80}})));
equation
    connect(theCon.port_b, vol.heatPort) annotation(
      Line(points = {{44, 42}, {59, 42}, {59, 32}, {80, 32}}, color = {191, 0, 0}));
    connect(preHea.port, vol.heatPort) annotation(
      Line(points = {{56, 80}, {56, 32}, {80, 32}}, color = {191, 0, 0}));
    connect(Tout_1.port, theCon.port_a) annotation(
      Line(points = {{6, 56}, {6, 42}, {24, 42}}, color = {191, 0, 0}));
    connect(fan.port_a, senTemHxOut.port_b) annotation(
      Line(points = {{50, -12}, {44, -12}, {44, -10}, {38, -10}}, color = {0, 127, 255}));
    connect(fan.port_b, vol.ports[1]) annotation(
      Line(points={{70,-12},{89,-12},{89,22}},        color = {0, 127, 255}));
    connect(fan.m_flow_in, mAir_flow.y) annotation(
      Line(points = {{60, 0}, {50.75, 0}, {50.75, 6}, {39.5, 6}, {39.5, 18}, {-16, 18}, {-16, 26}}, color = {0, 0, 127}));
    connect(cooCoi.port_a2, senTemSupAir.port_b) annotation(
      Line(points = {{-12, -4}, {-19, -4}, {-19, -3}, {-20, -3}}, color = {0, 127, 255}));
    connect(cooCoi.port_b2, senTemHxOut.port_a) annotation(
      Line(points = {{8, -4}, {13, -4}, {13, -10}, {18, -10}}, color = {0, 127, 255}));
    connect(cooCoi.port_a1, souWat.ports[1]) annotation(
      Line(points = {{8, -16}, {8, -20}, {5.5, -20}, {5.5, -24}, {15, -24}, {15, -76}, {12, -76}, {12, -74}, {-8, -74}, {-8, -90}}, color = {0, 127, 255}));
    connect(cooCoi.port_b1, sinWat.ports[1]) annotation(
      Line(points = {{-12, -16}, {-26, -16}, {-26, -52}, {-30, -52}}, color = {0, 127, 255}));
    connect(weaDat.weaBus, weaBus) annotation(
      Line(points = {{-196, 63}, {-116, 63}, {-116, 68}, {-46, 68}}, color = {255, 204, 51}, thickness = 0.5));
    connect(Tout_1.T, weaBus.TDryBul) annotation(
      Line(points = {{-16, 56}, {-32, 56}, {-32, 68.05}, {-45.95, 68.05}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{-2, 2}, {-2, 5}}, horizontalAlignment = TextAlignment.Right));
    connect(hex.port_b1, senTemSupAir.port_a) annotation(
      Line(points={{-52,-8},{-36,-8},{-36,-3}},        color = {0, 127, 255}));
    connect(hex.port_a2, vol.ports[2]) annotation(
      Line(points={{-52,-20},{91,-20},{91,22}},        color = {0, 127, 255}));
connect(out.ports[1], hex.port_a1) annotation(
      Line(points={{-90,35},{-78,35},{-78,-8},{-72,-8}},          color = {0, 127, 255}));
connect(hex.port_b2, out.ports[2]) annotation(
      Line(points={{-72,-20},{-80,-20},{-80,37},{-90,37}},       color = {0, 127, 255}));
connect(weaDat.weaBus, out.weaBus) annotation(
      Line(points={{-196,63},{-116,63},{-116,36.2},{-110,36.2}},
                                                       color = {255, 204, 51}, thickness = 0.5));
    connect(sub.u1, TRooSetPoint.y) annotation (Line(points={{-176,-60},{-198,
            -60},{-198,-42},{-206,-42}},
                              color={0,0,127}));
    connect(vol.heatPort, temperatureSensor.port) annotation (Line(points={{
            80,32},{74,32},{74,70},{106,70}}, color={191,0,0}));
    connect(temperatureSensor.T, sub.u2) annotation (Line(points={{127,70},{
            132,70},{132,-108},{-186,-108},{-186,-72},{-176,-72}}, color={0,0,
            127}));
    connect(sub.y, hys.u)
      annotation (Line(points={{-152,-66},{-144,-66}}, color={0,0,127}));
    connect(hys.y, mWatFlow.u) annotation (Line(points={{-120,-66},{-112,-66},
            {-112,-70},{-104,-70}}, color={255,0,255}));
    connect(souWat.m_flow_in, mWatFlow.y) annotation (Line(points={{-30,-82},
            {-72,-82},{-72,-70},{-80,-70}}, color={0,0,127}));
    annotation(
      experiment(StartTime = 1.5552e+07, StopTime = 1.56384e+07, Tolerance = 1e-06, Interval = 21.6867),
      __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "cvode", variableFilter = ".*"),
      Diagram(coordinateSystem(extent={{-240,-140},{200,120}})),
      Icon(coordinateSystem(extent={{-240,-140},{200,120}})),
__OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=backenddaeinfo,initialization -d=backenddaeinfo");
end SpaceCooling_Controlled;

model SpaceCooling_Controlled_Demand
 replaceable package MediumA=Buildings.Media.Air "Medium for Air";
 replaceable package MediumW=Buildings.Media.Water "Medium for water";
 parameter Modelica.Units.SI.Volume V=6*10*3;
 //parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600;
 parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000;
parameter Real eps = 0.8
  "Heat recovery effectiveness";

parameter Modelica.Units.SI.Temperature TRooSet=273.15 + 24
  "Nominal room air temperature";

parameter Modelica.Units.SI.Temperature TASup_nominal=273.15 + 18
  "Nominal air temperature supplied to room";

parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal = 0.012
  "Nominal supply air humidity ratio [kg/kg]";

parameter Modelica.Units.SI.Temperature TOut_nominal=273.15 + 30
  "Design outside air temperature";

parameter Modelica.Units.SI.Temperature THeaRecLvg =
  TOut_nominal - eps*(TOut_nominal - TRooSet)
  "Nominal air temperature leaving the heat recovery";

parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg = 0.0135
  "Nominal air humidity ratio [kg/kg] leaving the heat recovery";

parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal =
  -QRooInt_flow - 10E3/30*(TOut_nominal - TRooSet)
  "Nominal cooling load of the room";

parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal =
  1.3*QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
  "Nominal air mass flow rate";

parameter Modelica.Units.SI.TemperatureDifference dTFan = 2
  "Estimated temperature raise across fan";

parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal =
  mA_flow_nominal*(TASup_nominal - THeaRecLvg - dTFan)*1006
  + mA_flow_nominal*(wASup_nominal - wHeaRecLvg)*2458.3e3
  "Cooling load of coil, including sensible and latent load";

parameter Modelica.Units.SI.Temperature TWSup_nominal=273.15 + 12
  "Water supply temperature";

parameter Modelica.Units.SI.Temperature TWRet_nominal=273.15 + 16
  "Water return temperature";

parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal =
  -QCoiC_flow_nominal/(TWRet_nominal - TWSup_nominal)/4200
  "Nominal water mass flow rate";

Buildings.Fluid.MixingVolumes.MixingVolume vol(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, mSenFac = 3, m_flow_nominal = mA_flow_nominal, V = V, redeclare package Medium = Buildings.Media.Air
        "Moist air",                                                                                                                                                                                                        nPorts = 2)  annotation(
      Placement(transformation(origin = {90, 32}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G = 10000/30)  annotation(
      Placement(transformation(origin = {34, 42}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow = QRooInt_flow)  annotation(
      Placement(transformation(origin = {46, 80}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tout_1 annotation(
      Placement(transformation(origin = {-4, 56}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Movers.FlowControlled_m_flow fan(energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, m_flow_nominal = mA_flow_nominal, redeclare package Medium = Buildings.Media.Air "Moist air", addPowerToMedium = false)  annotation(
      Placement(transformation(origin = {60, -12}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(m1_flow_nominal = mA_flow_nominal, m2_flow_nominal = mA_flow_nominal, dp1_nominal = 200, dp2_nominal = 200, redeclare package Medium1 = Buildings.Media.Air "Moist air", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
      Placement(transformation(origin = {-62, -14}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(m1_flow_nominal = mW_flow_nominal, m2_flow_nominal = mA_flow_nominal, show_T = true, dp1_nominal = 6000, dp2_nominal = 200, use_Q_flow_nominal = true, Q_flow_nominal = QCoiC_flow_nominal, T_a1_nominal = TWSup_nominal, T_a2_nominal = THeaRecLvg, w_a2_nominal = wHeaRecLvg, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, redeclare package Medium1 = Buildings.Media.Water "Water", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
      Placement(transformation(origin = {-2, -10}, extent = {{10, 10}, {-10, -10}})));
Buildings.Fluid.Sources.MassFlowSource_T souWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water", use_m_flow_in = true, T = TWSup_nominal)  annotation(
      Placement(transformation(origin={-22,-84},    extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sources.Boundary_pT sinWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water")  annotation(
      Placement(transformation(origin = {-40, -52}, extent = {{-10, -10}, {10, 10}})));
Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      filNam=Modelica.Utilities.Files.loadResource(
          "modelica://TrainingBuilding_upd/Resources/SGP_Singapore.486980_IWEC.mos"),
      TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,                                                                                                                                                                                                      TDryBul = TOut_nominal, computeWetBulbTemperature = false)  annotation(
      Placement(transformation(origin={-193,81},   extent = {{-15, -13}, {15, 13}})));
 //  /modelica://Buildings/Resources/weatherdata/USA_IL_ChicagoOHare.Intl.AP.725300_TMY3.mos"
    Buildings.Fluid.Sensors.TemperatureTwoPort senTemHxOut(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {28, -10}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {-28, -3}, extent = {{-8, -9}, {8, 9}})));
Buildings.Controls.OBC.CDL.Reals.Sources.Constant mAir_flow(k = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {-28, 26}, extent = {{-10, -10}, {10, 10}})));
Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation(
      Placement(transformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sources.Outside out(redeclare package Medium = Buildings.Media.Air "Moist air", nPorts = 2)  annotation(
      Placement(transformation(origin={-100,36},   extent = {{-10, -10}, {10, 10}})));
    Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoint(k=297.15)
      annotation (Placement(transformation(origin={-2,16},    extent = {{-218, -46}, {-198, -26}})));
    Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(uLow=0, uHigh=1)
      annotation (Placement(transformation(extent={{-140,-74},{-120,-54}})));
    Buildings.Controls.OBC.CDL.Reals.Subtract sub
      annotation (Placement(transformation(extent={{-172,-30},{-152,-10}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToReal mWatFlow(realTrue=0,
        realFalse=mW_flow_nominal)
      annotation (Placement(transformation(extent={{-102,-80},{-82,-60}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
      annotation (Placement(transformation(extent={{106,60},{126,80}})));
    Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
      table={{0,297.15},{43200,297.15},{3600*15,297.15},{3600*24,297.15}},
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
      annotation (Placement(transformation(extent={{-218,12},{-198,32}})));
equation
    connect(theCon.port_b, vol.heatPort) annotation(
      Line(points = {{44, 42}, {59, 42}, {59, 32}, {80, 32}}, color = {191, 0, 0}));
    connect(preHea.port, vol.heatPort) annotation(
      Line(points = {{56, 80}, {56, 32}, {80, 32}}, color = {191, 0, 0}));
    connect(Tout_1.port, theCon.port_a) annotation(
      Line(points = {{6, 56}, {6, 42}, {24, 42}}, color = {191, 0, 0}));
    connect(fan.port_a, senTemHxOut.port_b) annotation(
      Line(points = {{50, -12}, {44, -12}, {44, -10}, {38, -10}}, color = {0, 127, 255}));
    connect(fan.port_b, vol.ports[1]) annotation(
      Line(points={{70,-12},{89,-12},{89,22}},        color = {0, 127, 255}));
    connect(fan.m_flow_in, mAir_flow.y) annotation(
      Line(points = {{60, 0}, {50.75, 0}, {50.75, 6}, {39.5, 6}, {39.5, 18}, {-16, 18}, {-16, 26}}, color = {0, 0, 127}));
    connect(cooCoi.port_a2, senTemSupAir.port_b) annotation(
      Line(points = {{-12, -4}, {-19, -4}, {-19, -3}, {-20, -3}}, color = {0, 127, 255}));
    connect(cooCoi.port_b2, senTemHxOut.port_a) annotation(
      Line(points = {{8, -4}, {13, -4}, {13, -10}, {18, -10}}, color = {0, 127, 255}));
    connect(cooCoi.port_a1, souWat.ports[1]) annotation(
      Line(points={{8,-16},{8,-84},{-12,-84}},                                                                                      color = {0, 127, 255}));
    connect(cooCoi.port_b1, sinWat.ports[1]) annotation(
      Line(points = {{-12, -16}, {-26, -16}, {-26, -52}, {-30, -52}}, color = {0, 127, 255}));
    connect(weaDat.weaBus, weaBus) annotation(
      Line(points = {{-178, 81}, {-116, 81}, {-116, 68}, {-46, 68}}, color = {255, 204, 51}, thickness = 0.5));
    connect(Tout_1.T, weaBus.TDryBul) annotation(
      Line(points = {{-16, 56}, {-32, 56}, {-32, 68.05}, {-45.95, 68.05}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{-2, 2}, {-2, 5}}, horizontalAlignment = TextAlignment.Right));
    connect(hex.port_b1, senTemSupAir.port_a) annotation(
      Line(points={{-52,-8},{-36,-8},{-36,-3}},        color = {0, 127, 255}));
    connect(hex.port_a2, vol.ports[2]) annotation(
      Line(points={{-52,-20},{91,-20},{91,22}},        color = {0, 127, 255}));
connect(out.ports[1], hex.port_a1) annotation(
      Line(points={{-90,35},{-78,35},{-78,-8},{-72,-8}},          color = {0, 127, 255}));
connect(hex.port_b2, out.ports[2]) annotation(
      Line(points={{-72,-20},{-80,-20},{-80,37},{-90,37}},       color = {0, 127, 255}));
connect(weaDat.weaBus, out.weaBus) annotation(
      Line(points={{-178,81},{-116,81},{-116,36.2},{-110,36.2}},
                                                       color = {255, 204, 51}, thickness = 0.5));
    connect(vol.heatPort, temperatureSensor.port) annotation (Line(points={{
            80,32},{74,32},{74,70},{106,70}}, color={191,0,0}));
    connect(temperatureSensor.T, sub.u2) annotation (Line(points={{127,70},{
            130,70},{130,-118},{-182,-118},{-182,-26},{-174,-26}}, color={0,0,
            127}));
    connect(sub.y, hys.u)
      annotation (Line(points={{-150,-20},{-142,-20},{-142,-50},{-152,-50},{
            -152,-64},{-142,-64}},                     color={0,0,127}));
    connect(hys.y, mWatFlow.u) annotation (Line(points={{-118,-64},{-112,-64},
            {-112,-70},{-104,-70}}, color={255,0,255}));
    connect(souWat.m_flow_in, mWatFlow.y) annotation (Line(points={{-34,-76},
            {-58,-76},{-58,-70},{-80,-70}}, color={0,0,127}));
    connect(combiTimeTable.y[1], sub.u1) annotation (Line(points={{-197,22},{
            -184,22},{-184,-14},{-174,-14}}, color={0,0,127}));
    annotation(
      experiment(StartTime = 1.5552e+07, StopTime = 1.56384e+07, Tolerance = 1e-06, Interval = 21.6867),
      __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "cvode", variableFilter = ".*"),
      Diagram(coordinateSystem(extent={{-240,-140},{200,120}})),
      Icon(coordinateSystem(extent={{-240,-140},{200,120}})),
__OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=backenddaeinfo,initialization -d=backenddaeinfo");
end SpaceCooling_Controlled_Demand;

model SpaceCooling_Controlled_Demand_PI
 replaceable package MediumA=Buildings.Media.Air "Medium for Air";
 replaceable package MediumW=Buildings.Media.Water "Medium for water";
 parameter Modelica.Units.SI.Volume V=6*10*3;
 //parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600;
 parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000;
parameter Real eps = 0.8
  "Heat recovery effectiveness";

parameter Modelica.Units.SI.Temperature TRooSet=273.15 + 24
  "Nominal room air temperature";

parameter Modelica.Units.SI.Temperature TASup_nominal=273.15 + 18
  "Nominal air temperature supplied to room";

parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal = 0.012
  "Nominal supply air humidity ratio [kg/kg]";

parameter Modelica.Units.SI.Temperature TOut_nominal=273.15 + 30
  "Design outside air temperature";

parameter Modelica.Units.SI.Temperature THeaRecLvg =
  TOut_nominal - eps*(TOut_nominal - TRooSet)
  "Nominal air temperature leaving the heat recovery";

parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg = 0.0135
  "Nominal air humidity ratio [kg/kg] leaving the heat recovery";

parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal =
  -QRooInt_flow - 10E3/30*(TOut_nominal - TRooSet)
  "Nominal cooling load of the room";

parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal =
  1.3*QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
  "Nominal air mass flow rate";

parameter Modelica.Units.SI.TemperatureDifference dTFan = 2
  "Estimated temperature raise across fan";

parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal =
  mA_flow_nominal*(TASup_nominal - THeaRecLvg - dTFan)*1006
  + mA_flow_nominal*(wASup_nominal - wHeaRecLvg)*2458.3e3
  "Cooling load of coil, including sensible and latent load";

parameter Modelica.Units.SI.Temperature TWSup_nominal=273.15 + 12
  "Water supply temperature";

parameter Modelica.Units.SI.Temperature TWRet_nominal=273.15 + 16
  "Water return temperature";

parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal =
  -QCoiC_flow_nominal/(TWRet_nominal - TWSup_nominal)/4200
  "Nominal water mass flow rate";

Buildings.Fluid.MixingVolumes.MixingVolume vol(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, mSenFac = 3, m_flow_nominal = mA_flow_nominal, V = V, redeclare package Medium = Buildings.Media.Air
        "Moist air",                                                                                                                                                                                                        nPorts = 2)  annotation(
      Placement(transformation(origin = {90, 32}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G = 10000/30)  annotation(
      Placement(transformation(origin = {34, 42}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow = QRooInt_flow)  annotation(
      Placement(transformation(origin = {46, 80}, extent = {{-10, -10}, {10, 10}})));
Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tout_1 annotation(
      Placement(transformation(origin = {-4, 56}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Movers.FlowControlled_m_flow fan(energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, m_flow_nominal = mA_flow_nominal, redeclare package Medium = Buildings.Media.Air "Moist air", addPowerToMedium = false)  annotation(
      Placement(transformation(origin = {60, -12}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(m1_flow_nominal = mA_flow_nominal, m2_flow_nominal = mA_flow_nominal, dp1_nominal = 200, dp2_nominal = 200, redeclare package Medium1 = Buildings.Media.Air "Moist air", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
      Placement(transformation(origin = {-62, -14}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(m1_flow_nominal = mW_flow_nominal, m2_flow_nominal = mA_flow_nominal, show_T = true, dp1_nominal = 6000, dp2_nominal = 200, use_Q_flow_nominal = true, Q_flow_nominal = QCoiC_flow_nominal, T_a1_nominal = TWSup_nominal, T_a2_nominal = THeaRecLvg, w_a2_nominal = wHeaRecLvg, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, redeclare package Medium1 = Buildings.Media.Water "Water", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
      Placement(transformation(origin = {-2, -14}, extent = {{10, 10}, {-10, -10}})));
Buildings.Fluid.Sources.MassFlowSource_T souWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water", use_m_flow_in = true, T = TWSup_nominal)  annotation(
      Placement(transformation(origin={-16,-104},   extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sources.Boundary_pT sinWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water")  annotation(
      Placement(transformation(origin = {-40, -52}, extent = {{-10, -10}, {10, 10}})));
Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam = "C:/Users/jadhe/OneDrive/Documents/Dymola/Buildings 13.0.0/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
      TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,                                                                                                                                                                                                      TDryBul = TOut_nominal, computeWetBulbTemperature = false)  annotation(
      Placement(transformation(origin={-195,81},   extent = {{-15, -13}, {15, 13}})));
 //  /modelica://Buildings/Resources/weatherdata/USA_IL_ChicagoOHare.Intl.AP.725300_TMY3.mos"
    Buildings.Fluid.Sensors.TemperatureTwoPort senTemHxOut(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {28, -10}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
      Placement(transformation(origin = {-28, -3}, extent = {{-8, -9}, {8, 9}})));
Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation(
      Placement(transformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}})));
Buildings.Fluid.Sources.Outside out(redeclare package Medium = Buildings.Media.Air "Moist air", nPorts = 2)  annotation(
      Placement(transformation(origin={-100,36},   extent = {{-10, -10}, {10, 10}})));
    Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoint(k=297.15)
      annotation (Placement(transformation(origin={32,38},    extent = {{-218, -46}, {-198, -26}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
      annotation (Placement(transformation(extent={{106,60},{126,80}})));
    Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
      table={{0,297.15},{43200,297.15},{3600*15,297.15},{3600*24,297.15}},
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
      annotation (Placement(transformation(origin = {32, -56}, extent = {{-218, 12}, {-198, 32}})));
    Buildings.Controls.OBC.CDL.Reals.PID conPID(
      k= 0.01,
      Ti= 30,
      yMax=2*mW_flow_nominal,
      yMin= 0.01, reverseActing = false, r = 1)
      annotation (Placement(transformation(origin = {-6, -22}, extent = {{-126, -52}, {-106, -32}})));
Buildings.Controls.OBC.CDL.Reals.Sources.Constant mAir_flow(k = mA_flow_nominal) annotation(
      Placement(transformation(origin = {2, 18}, extent = {{-10, -10}, {10, 10}})));
equation
    connect(theCon.port_b, vol.heatPort) annotation(
      Line(points = {{44, 42}, {59, 42}, {59, 32}, {80, 32}}, color = {191, 0, 0}));
    connect(preHea.port, vol.heatPort) annotation(
      Line(points = {{56, 80}, {56, 32}, {80, 32}}, color = {191, 0, 0}));
    connect(Tout_1.port, theCon.port_a) annotation(
      Line(points = {{6, 56}, {6, 42}, {24, 42}}, color = {191, 0, 0}));
    connect(fan.port_a, senTemHxOut.port_b) annotation(
      Line(points = {{50, -12}, {44, -12}, {44, -10}, {38, -10}}, color = {0, 127, 255}));
    connect(fan.port_b, vol.ports[1]) annotation(
      Line(points = {{70, -12}, {89, -12}, {89, 22}}, color = {0, 127, 255}));
    connect(cooCoi.port_a2, senTemSupAir.port_b) annotation(
      Line(points = {{-12, -8}, {-19, -8}, {-19, -3}, {-20, -3}}, color = {0, 127, 255}));
    connect(cooCoi.port_b2, senTemHxOut.port_a) annotation(
      Line(points = {{8, -8}, {13, -8}, {13, -10}, {18, -10}}, color = {0, 127, 255}));
    connect(cooCoi.port_a1, souWat.ports[1]) annotation(
      Line(points = {{8, -20}, {8, -104}, {-6, -104}}, color = {0, 127, 255}));
    connect(cooCoi.port_b1, sinWat.ports[1]) annotation(
      Line(points = {{-12, -20}, {-26, -20}, {-26, -52}, {-30, -52}}, color = {0, 127, 255}));
    connect(weaDat.weaBus, weaBus) annotation(
      Line(points = {{-180, 81}, {-116, 81}, {-116, 68}, {-46, 68}}, color = {255, 204, 51}, thickness = 0.5));
    connect(Tout_1.T, weaBus.TDryBul) annotation(
      Line(points = {{-16, 56}, {-32, 56}, {-32, 68.05}, {-45.95, 68.05}}, color = {0, 0, 127}),
      Text(string = "%second", index = 1, extent = {{-2, 2}, {-2, 5}}, horizontalAlignment = TextAlignment.Right));
    connect(hex.port_b1, senTemSupAir.port_a) annotation(
      Line(points = {{-52, -8}, {-36, -8}, {-36, -3}}, color = {0, 127, 255}));
    connect(hex.port_a2, vol.ports[2]) annotation(
      Line(points = {{-52, -20}, {91, -20}, {91, 22}}, color = {0, 127, 255}));
    connect(out.ports[1], hex.port_a1) annotation(
      Line(points = {{-90, 35}, {-78, 35}, {-78, -8}, {-72, -8}}, color = {0, 127, 255}));
    connect(hex.port_b2, out.ports[2]) annotation(
      Line(points = {{-72, -20}, {-80, -20}, {-80, 37}, {-90, 37}}, color = {0, 127, 255}));
    connect(weaDat.weaBus, out.weaBus) annotation(
      Line(points = {{-180, 81}, {-116, 81}, {-116, 36.2}, {-110, 36.2}}, color = {255, 204, 51}, thickness = 0.5));
    connect(vol.heatPort, temperatureSensor.port) annotation(
      Line(points = {{80, 32}, {74, 32}, {74, 70}, {106, 70}}, color = {191, 0, 0}));
    connect(combiTimeTable.y[1], conPID.u_s) annotation(
      Line(points = {{-165, -34}, {-134, -34}, {-134, -64}}, color = {0, 0, 127}));
    connect(temperatureSensor.T, conPID.u_m) annotation(
      Line(points = {{127, 70}, {136, 70}, {136, -128}, {-122, -128}, {-122, -76}}, color = {0, 0, 127}));
    connect(conPID.y, souWat.m_flow_in) annotation(
      Line(points = {{-110, -64}, {-56, -64}, {-56, -96}, {-28, -96}}, color = {0, 0, 127}));
connect(mAir_flow.y, fan.m_flow_in) annotation(
      Line(points = {{14, 18}, {60, 18}, {60, 0}}, color = {0, 0, 127}));
    annotation(
      experiment(StartTime = 1.5552e+07, StopTime = 1.56384e+07, Tolerance = 1e-06, Interval = 21.6867),
      __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "cvode", variableFilter = ".*"),
      Diagram(coordinateSystem(extent={{-240,-140},{200,120}})),
      Icon(coordinateSystem(extent={{-240,-140},{200,120}})),
__OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=backenddaeinfo,initialization -d=backenddaeinfo");
end SpaceCooling_Controlled_Demand_PI;

  model SpaceCooling_Controlled_Demand_Hysteresis
   replaceable package MediumA=Buildings.Media.Air "Medium for Air";
   replaceable package MediumW=Buildings.Media.Water "Medium for water";
   parameter Modelica.Units.SI.Volume V=6*10*3;
   //parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600;
   parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000;
  parameter Real eps = 0.8
    "Heat recovery effectiveness";

  parameter Modelica.Units.SI.Temperature TRooSet=273.15 + 24
    "Nominal room air temperature";

  parameter Modelica.Units.SI.Temperature TASup_nominal=273.15 + 18
    "Nominal air temperature supplied to room";

  parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal = 0.012
    "Nominal supply air humidity ratio [kg/kg]";

  parameter Modelica.Units.SI.Temperature TOut_nominal=273.15 + 30
    "Design outside air temperature";

  parameter Modelica.Units.SI.Temperature THeaRecLvg =
    TOut_nominal - eps*(TOut_nominal - TRooSet)
    "Nominal air temperature leaving the heat recovery";

  parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg = 0.0135
    "Nominal air humidity ratio [kg/kg] leaving the heat recovery";

  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal =
    -QRooInt_flow - 10E3/30*(TOut_nominal - TRooSet)
    "Nominal cooling load of the room";

  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal =
    1.3*QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
    "Nominal air mass flow rate";

  parameter Modelica.Units.SI.TemperatureDifference dTFan = 2
    "Estimated temperature raise across fan";

  parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal =
    mA_flow_nominal*(TASup_nominal - THeaRecLvg - dTFan)*1006
    + mA_flow_nominal*(wASup_nominal - wHeaRecLvg)*2458.3e3
    "Cooling load of coil, including sensible and latent load";

  parameter Modelica.Units.SI.Temperature TWSup_nominal=273.15 + 12
    "Water supply temperature";

  parameter Modelica.Units.SI.Temperature TWRet_nominal=273.15 + 16
    "Water return temperature";

  parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal =
    -QCoiC_flow_nominal/(TWRet_nominal - TWSup_nominal)/4200
    "Nominal water mass flow rate";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, mSenFac = 3, m_flow_nominal = mA_flow_nominal, V = V, redeclare package Medium = Buildings.Media.Air
          "Moist air",                                                                                                                                                                                                        nPorts = 2)  annotation(
        Placement(transformation(origin = {90, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G = 10000/30)  annotation(
        Placement(transformation(origin = {34, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow = QRooInt_flow)  annotation(
        Placement(transformation(origin = {46, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tout_1 annotation(
        Placement(transformation(origin = {-4, 56}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, m_flow_nominal = mA_flow_nominal, redeclare package Medium = Buildings.Media.Air "Moist air", addPowerToMedium = false)  annotation(
        Placement(transformation(origin = {60, -12}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(m1_flow_nominal = mA_flow_nominal, m2_flow_nominal = mA_flow_nominal, dp1_nominal = 200, dp2_nominal = 200, redeclare package Medium1 = Buildings.Media.Air "Moist air", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
        Placement(transformation(origin = {-62, -14}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(m1_flow_nominal = mW_flow_nominal, m2_flow_nominal = mA_flow_nominal, show_T = true, dp1_nominal = 6000, dp2_nominal = 200, use_Q_flow_nominal = true, Q_flow_nominal = QCoiC_flow_nominal, T_a1_nominal = TWSup_nominal, T_a2_nominal = THeaRecLvg, w_a2_nominal = wHeaRecLvg, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, redeclare package Medium1 = Buildings.Media.Water "Water", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
        Placement(transformation(origin = {-2, -10}, extent = {{10, 10}, {-10, -10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water", use_m_flow_in = true, T = TWSup_nominal)  annotation(
        Placement(transformation(origin={-16,-104},   extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water")  annotation(
        Placement(transformation(origin = {-40, -52}, extent = {{-10, -10}, {10, 10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam = "C:/Users/jadhe/OneDrive/Documents/Dymola/Buildings 13.0.0/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
        TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,                                                                                                                                                                                                      TDryBul = TOut_nominal, computeWetBulbTemperature = false)  annotation(
        Placement(transformation(origin={-195,81},   extent = {{-15, -13}, {15, 13}})));
  //  /modelica://Buildings/Resources/weatherdata/USA_IL_ChicagoOHare.Intl.AP.725300_TMY3.mos"
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHxOut(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
        Placement(transformation(origin = {28, -10}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
        Placement(transformation(origin = {-28, -3}, extent = {{-8, -9}, {8, 9}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant mAir_flow(k = mA_flow_nominal)  annotation(
        Placement(transformation(origin = {-28, 26}, extent = {{-10, -10}, {10, 10}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation(
        Placement(transformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Outside out(redeclare package Medium = Buildings.Media.Air "Moist air", nPorts = 2)  annotation(
        Placement(transformation(origin={-100,36},   extent = {{-10, -10}, {10, 10}})));
      Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoint(k=297.15)
        annotation (Placement(transformation(origin={34,10},    extent = {{-218, -46}, {-198, -26}})));
      Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
        annotation (Placement(transformation(extent={{106,60},{126,80}})));
      Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
        table={{0,297.15},{43200,297.15},{3600*15,297.15},{3600*24,297.15}},
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
        extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
        annotation (Placement(transformation(origin = {32, -10}, extent = {{-218, 12}, {-198, 32}})));
      Buildings.Controls.OBC.CDL.Reals.PID conPID(
        k= 0.01,
        Ti= 30,
        yMax=2*mW_flow_nominal,
        yMin= 0, reverseActing = false)
        annotation (Placement(transformation(extent={{-126,-52},{-106,-32}})));
  equation
      connect(theCon.port_b, vol.heatPort) annotation(
        Line(points = {{44, 42}, {59, 42}, {59, 32}, {80, 32}}, color = {191, 0, 0}));
      connect(preHea.port, vol.heatPort) annotation(
        Line(points = {{56, 80}, {56, 32}, {80, 32}}, color = {191, 0, 0}));
      connect(Tout_1.port, theCon.port_a) annotation(
        Line(points = {{6, 56}, {6, 42}, {24, 42}}, color = {191, 0, 0}));
      connect(fan.port_a, senTemHxOut.port_b) annotation(
        Line(points = {{50, -12}, {44, -12}, {44, -10}, {38, -10}}, color = {0, 127, 255}));
      connect(fan.port_b, vol.ports[1]) annotation(
        Line(points={{70,-12},{89,-12},{89,22}},        color = {0, 127, 255}));
      connect(fan.m_flow_in, mAir_flow.y) annotation(
        Line(points = {{60, 0}, {50.75, 0}, {50.75, 6}, {39.5, 6}, {39.5, 18}, {-16, 18}, {-16, 26}}, color = {0, 0, 127}));
      connect(cooCoi.port_a2, senTemSupAir.port_b) annotation(
        Line(points = {{-12, -4}, {-19, -4}, {-19, -3}, {-20, -3}}, color = {0, 127, 255}));
      connect(cooCoi.port_b2, senTemHxOut.port_a) annotation(
        Line(points = {{8, -4}, {13, -4}, {13, -10}, {18, -10}}, color = {0, 127, 255}));
      connect(cooCoi.port_a1, souWat.ports[1]) annotation(
        Line(points={{8,-16},{8,-104},{-6,-104}},                                                                                     color = {0, 127, 255}));
      connect(cooCoi.port_b1, sinWat.ports[1]) annotation(
        Line(points = {{-12, -16}, {-26, -16}, {-26, -52}, {-30, -52}}, color = {0, 127, 255}));
      connect(weaDat.weaBus, weaBus) annotation(
        Line(points = {{-180, 81}, {-116, 81}, {-116, 68}, {-46, 68}}, color = {255, 204, 51}, thickness = 0.5));
      connect(Tout_1.T, weaBus.TDryBul) annotation(
        Line(points = {{-16, 56}, {-32, 56}, {-32, 68.05}, {-45.95, 68.05}}, color = {0, 0, 127}),
        Text(string = "%second", index = 1, extent = {{-2, 2}, {-2, 5}}, horizontalAlignment = TextAlignment.Right));
      connect(hex.port_b1, senTemSupAir.port_a) annotation(
        Line(points={{-52,-8},{-36,-8},{-36,-3}},        color = {0, 127, 255}));
      connect(hex.port_a2, vol.ports[2]) annotation(
        Line(points={{-52,-20},{91,-20},{91,22}},        color = {0, 127, 255}));
  connect(out.ports[1], hex.port_a1) annotation(
        Line(points={{-90,35},{-78,35},{-78,-8},{-72,-8}},          color = {0, 127, 255}));
  connect(hex.port_b2, out.ports[2]) annotation(
        Line(points={{-72,-20},{-80,-20},{-80,37},{-90,37}},       color = {0, 127, 255}));
  connect(weaDat.weaBus, out.weaBus) annotation(
        Line(points={{-180,81},{-116,81},{-116,36.2},{-110,36.2}},
                                                         color = {255, 204, 51}, thickness = 0.5));
      connect(vol.heatPort, temperatureSensor.port) annotation (Line(points={{
              80,32},{74,32},{74,70},{106,70}}, color={191,0,0}));
      connect(combiTimeTable.y[1], conPID.u_s) annotation (Line(points={{-165,
              12},{-136,12},{-136,-42},{-128,-42}}, color={0,0,127}));
      connect(temperatureSensor.T, conPID.u_m) annotation (Line(points={{127,70},
              {136,70},{136,-126},{-116,-126},{-116,-54}}, color={0,0,127}));
      connect(conPID.y, souWat.m_flow_in) annotation (Line(points={{-104,-42},{
              -56,-42},{-56,-96},{-28,-96}}, color={0,0,127}));
      annotation(
        experiment(StartTime = 1.5552e+07, StopTime = 1.56384e+07, Tolerance = 1e-06, Interval = 21.6867),
        __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "cvode", variableFilter = ".*"),
        Diagram(coordinateSystem(extent={{-240,-140},{200,120}})),
        Icon(coordinateSystem(extent={{-240,-140},{200,120}})),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=backenddaeinfo,initialization -d=backenddaeinfo");
  end SpaceCooling_Controlled_Demand_Hysteresis;

  model SpaceCooling_Controlled_Demand_PI2
   replaceable package MediumA=Buildings.Media.Air "Medium for Air";
   replaceable package MediumW=Buildings.Media.Water "Medium for water";
   parameter Modelica.Units.SI.Volume V=6*10*3;
   //parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600;
   parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000;
  parameter Real eps = 0.8
    "Heat recovery effectiveness";

  parameter Modelica.Units.SI.Temperature TRooSet=273.15 + 24
    "Nominal room air temperature";

  parameter Modelica.Units.SI.Temperature TASup_nominal=273.15 + 18
    "Nominal air temperature supplied to room";

  parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal = 0.012
    "Nominal supply air humidity ratio [kg/kg]";

  parameter Modelica.Units.SI.Temperature TOut_nominal=273.15 + 30
    "Design outside air temperature";

  parameter Modelica.Units.SI.Temperature THeaRecLvg =
    TOut_nominal - eps*(TOut_nominal - TRooSet)
    "Nominal air temperature leaving the heat recovery";

  parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg = 0.0135
    "Nominal air humidity ratio [kg/kg] leaving the heat recovery";

  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal =
    -QRooInt_flow - 10E3/30*(TOut_nominal - TRooSet)
    "Nominal cooling load of the room";

  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal =
    1.3*QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
    "Nominal air mass flow rate";

  parameter Modelica.Units.SI.TemperatureDifference dTFan = 2
    "Estimated temperature raise across fan";

  parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal =
    mA_flow_nominal*(TASup_nominal - THeaRecLvg - dTFan)*1006
    + mA_flow_nominal*(wASup_nominal - wHeaRecLvg)*2458.3e3
    "Cooling load of coil, including sensible and latent load";

  parameter Modelica.Units.SI.Temperature TWSup_nominal=273.15 + 12
    "Water supply temperature";

  parameter Modelica.Units.SI.Temperature TWRet_nominal=273.15 + 16
    "Water return temperature";

  parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal =
    -QCoiC_flow_nominal/(TWRet_nominal - TWSup_nominal)/4200
    "Nominal water mass flow rate";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, mSenFac = 3, m_flow_nominal = mA_flow_nominal, V = V, redeclare package Medium = Buildings.Media.Air
          "Moist air",                                                                                                                                                                                                        nPorts = 2)  annotation(
        Placement(transformation(origin = {90, 32}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G = 10000/30)  annotation(
        Placement(transformation(origin = {34, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow = QRooInt_flow)  annotation(
        Placement(transformation(origin = {46, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tout_1 annotation(
        Placement(transformation(origin = {-4, 56}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, m_flow_nominal = mA_flow_nominal, redeclare package Medium = Buildings.Media.Air "Moist air", addPowerToMedium = false)  annotation(
        Placement(transformation(origin = {60, -12}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(m1_flow_nominal = mA_flow_nominal, m2_flow_nominal = mA_flow_nominal, dp1_nominal = 200, dp2_nominal = 200, redeclare package Medium1 = Buildings.Media.Air "Moist air", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
        Placement(transformation(origin = {-62, -14}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(m1_flow_nominal = mW_flow_nominal, m2_flow_nominal = mA_flow_nominal, show_T = true, dp1_nominal = 6000, dp2_nominal = 200, use_Q_flow_nominal = true, Q_flow_nominal = QCoiC_flow_nominal, T_a1_nominal = TWSup_nominal, T_a2_nominal = THeaRecLvg, w_a2_nominal = wHeaRecLvg, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, redeclare package Medium1 = Buildings.Media.Water "Water", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
        Placement(transformation(origin = {-2, -10}, extent = {{10, 10}, {-10, -10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water", use_m_flow_in = true, T = TWSup_nominal)  annotation(
        Placement(transformation(origin={-16,-104},   extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water")  annotation(
        Placement(transformation(origin = {-40, -52}, extent = {{-10, -10}, {10, 10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam = "C:/Users/jadhe/OneDrive/Documents/Dymola/Buildings 13.0.0/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
        TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,                                                                                                                                                                                                      TDryBul = TOut_nominal, computeWetBulbTemperature = false)  annotation(
        Placement(transformation(origin={-195,81},   extent = {{-15, -13}, {15, 13}})));
  //  /modelica://Buildings/Resources/weatherdata/USA_IL_ChicagoOHare.Intl.AP.725300_TMY3.mos"
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHxOut(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
        Placement(transformation(origin = {28, -10}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
        Placement(transformation(origin = {-28, -3}, extent = {{-8, -9}, {8, 9}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation(
        Placement(transformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Outside out(redeclare package Medium = Buildings.Media.Air "Moist air", nPorts = 2)  annotation(
        Placement(transformation(origin={-100,36},   extent = {{-10, -10}, {10, 10}})));
      Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoint(k=297.15)
        annotation (Placement(transformation(origin={32,16},    extent = {{-218, -46}, {-198, -26}})));
      Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
        annotation (Placement(transformation(extent={{106,60},{126,80}})));
      Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
        table={{0,297.15},{43200,297.15},{3600*15,297.15},{3600*24,297.15}},
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
        extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
        annotation (Placement(transformation(origin = {32, -10}, extent = {{-218, 12}, {-198, 32}})));
      Buildings.Controls.OBC.CDL.Reals.PID conPID(
        k= 0.01,
        Ti= 30,
        yMax=2*mW_flow_nominal,
        yMin= 0, reverseActing = false)
        annotation (Placement(transformation(extent={{-126,-52},{-106,-32}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPID1(Ti = 30, k = 0.01, reverseActing = false, yMax = mA_flow_nominal, yMin = 0.01) annotation(
        Placement(transformation(origin = {150, -14}, extent = {{-126, -52}, {-106, -32}})));
  equation
      connect(theCon.port_b, vol.heatPort) annotation(
        Line(points = {{44, 42}, {59, 42}, {59, 32}, {80, 32}}, color = {191, 0, 0}));
      connect(preHea.port, vol.heatPort) annotation(
        Line(points = {{56, 80}, {56, 32}, {80, 32}}, color = {191, 0, 0}));
      connect(Tout_1.port, theCon.port_a) annotation(
        Line(points = {{6, 56}, {6, 42}, {24, 42}}, color = {191, 0, 0}));
      connect(fan.port_a, senTemHxOut.port_b) annotation(
        Line(points = {{50, -12}, {44, -12}, {44, -10}, {38, -10}}, color = {0, 127, 255}));
      connect(fan.port_b, vol.ports[1]) annotation(
        Line(points = {{70, -12}, {89, -12}, {89, 22}}, color = {0, 127, 255}));
      connect(cooCoi.port_a2, senTemSupAir.port_b) annotation(
        Line(points = {{-12, -4}, {-19, -4}, {-19, -3}, {-20, -3}}, color = {0, 127, 255}));
      connect(cooCoi.port_b2, senTemHxOut.port_a) annotation(
        Line(points = {{8, -4}, {13, -4}, {13, -10}, {18, -10}}, color = {0, 127, 255}));
      connect(cooCoi.port_a1, souWat.ports[1]) annotation(
        Line(points = {{8, -16}, {8, -104}, {-6, -104}}, color = {0, 127, 255}));
      connect(cooCoi.port_b1, sinWat.ports[1]) annotation(
        Line(points = {{-12, -16}, {-26, -16}, {-26, -52}, {-30, -52}}, color = {0, 127, 255}));
      connect(weaDat.weaBus, weaBus) annotation(
        Line(points = {{-180, 81}, {-116, 81}, {-116, 68}, {-46, 68}}, color = {255, 204, 51}, thickness = 0.5));
      connect(Tout_1.T, weaBus.TDryBul) annotation(
        Line(points = {{-16, 56}, {-32, 56}, {-32, 68.05}, {-45.95, 68.05}}, color = {0, 0, 127}),
        Text(string = "%second", index = 1, extent = {{-2, 2}, {-2, 5}}, horizontalAlignment = TextAlignment.Right));
      connect(hex.port_b1, senTemSupAir.port_a) annotation(
        Line(points = {{-52, -8}, {-36, -8}, {-36, -3}}, color = {0, 127, 255}));
      connect(hex.port_a2, vol.ports[2]) annotation(
        Line(points = {{-52, -20}, {91, -20}, {91, 22}}, color = {0, 127, 255}));
      connect(out.ports[1], hex.port_a1) annotation(
        Line(points = {{-90, 35}, {-78, 35}, {-78, -8}, {-72, -8}}, color = {0, 127, 255}));
      connect(hex.port_b2, out.ports[2]) annotation(
        Line(points = {{-72, -20}, {-80, -20}, {-80, 37}, {-90, 37}}, color = {0, 127, 255}));
      connect(weaDat.weaBus, out.weaBus) annotation(
        Line(points = {{-180, 81}, {-116, 81}, {-116, 36.2}, {-110, 36.2}}, color = {255, 204, 51}, thickness = 0.5));
      connect(vol.heatPort, temperatureSensor.port) annotation(
        Line(points = {{80, 32}, {74, 32}, {74, 70}, {106, 70}}, color = {191, 0, 0}));
      connect(combiTimeTable.y[1], conPID.u_s) annotation(
        Line(points = {{-165, 12}, {-136, 12}, {-136, -42}, {-128, -42}}, color = {0, 0, 127}));
      connect(temperatureSensor.T, conPID.u_m) annotation(
        Line(points = {{127, 70}, {136, 70}, {136, -126}, {-116, -126}, {-116, -54}}, color = {0, 0, 127}));
      connect(conPID.y, souWat.m_flow_in) annotation(
        Line(points = {{-104, -42}, {-56, -42}, {-56, -96}, {-28, -96}}, color = {0, 0, 127}));
  connect(temperatureSensor.T, conPID1.u_m) annotation(
        Line(points = {{128, 70}, {107.5, 70}, {107.5, 16}, {107, 16}, {107, -76}, {112, -76}, {112, -75}, {50, -75}, {50, -75.5}, {34, -75.5}, {34, -68}}, color = {0, 0, 127}));
  connect(combiTimeTable.y[1], conPID1.u_s) annotation(
        Line(points = {{-164, 12}, {22, 12}, {22, -56}}, color = {0, 0, 127}));
  connect(conPID1.y, fan.m_flow_in) annotation(
        Line(points = {{46, -56}, {60, -56}, {60, 0}}, color = {0, 0, 127}));
      annotation(
        experiment(StartTime = 1.5552e+07, StopTime = 1.56384e+07, Tolerance = 1e-06, Interval = 21.6867),
        __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "cvode", variableFilter = ".*"),
        Diagram(coordinateSystem(extent={{-240,-140},{200,120}})),
        Icon(coordinateSystem(extent={{-240,-140},{200,120}})),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=backenddaeinfo,initialization -d=backenddaeinfo");
  end SpaceCooling_Controlled_Demand_PI2;

  model SpaceCooling_Controlled_Demand_PI_Heat
   replaceable package MediumA=Buildings.Media.Air "Medium for Air";
   replaceable package MediumW=Buildings.Media.Water "Medium for water";
   parameter Modelica.Units.SI.Volume V=6*10*3;
   //parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600;
   parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000;
  parameter Real eps = 0.8
    "Heat recovery effectiveness";

  parameter Modelica.Units.SI.Temperature TRooSet=273.15 + 24
    "Nominal room air temperature";

  parameter Modelica.Units.SI.Temperature TASup_nominal=273.15 + 18
    "Nominal air temperature supplied to room";

  parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal = 0.012
    "Nominal supply air humidity ratio [kg/kg]";

  parameter Modelica.Units.SI.Temperature TOut_nominal=273.15 + 30
    "Design outside air temperature";

  parameter Modelica.Units.SI.Temperature THeaRecLvg =
    TOut_nominal - eps*(TOut_nominal - TRooSet)
    "Nominal air temperature leaving the heat recovery";

  parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg = 0.0135
    "Nominal air humidity ratio [kg/kg] leaving the heat recovery";

  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal =
    -QRooInt_flow - 10E3/30*(TOut_nominal - TRooSet)
    "Nominal cooling load of the room";

  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal =
    1.3*QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
    "Nominal air mass flow rate";

  parameter Modelica.Units.SI.TemperatureDifference dTFan = 2
    "Estimated temperature raise across fan";

  parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal =
    mA_flow_nominal*(TASup_nominal - THeaRecLvg - dTFan)*1006
    + mA_flow_nominal*(wASup_nominal - wHeaRecLvg)*2458.3e3
    "Cooling load of coil, including sensible and latent load";

  parameter Modelica.Units.SI.Temperature TWSup_nominal=273.15 + 12
    "Water supply temperature";

  parameter Modelica.Units.SI.Temperature TWRet_nominal=273.15 + 16
    "Water return temperature";

  parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal =
    -QCoiC_flow_nominal/(TWRet_nominal - TWSup_nominal)/4200
    "Nominal water mass flow rate";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, mSenFac = 3, m_flow_nominal = mA_flow_nominal, V = V, redeclare package Medium = Buildings.Media.Air
          "Moist air",                                                                                                                                                                                                        nPorts = 2)  annotation(
        Placement(transformation(origin = {94, 86}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G = 10000/30)  annotation(
        Placement(transformation(origin = {30, 66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow = QRooInt_flow)  annotation(
        Placement(transformation(origin = {42, 102}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tout_1 annotation(
        Placement(transformation(origin = {-12, 86}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, m_flow_nominal = mA_flow_nominal, redeclare package Medium = Buildings.Media.Air "Moist air", addPowerToMedium = false)  annotation(
        Placement(transformation(origin = {60, -12}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(m1_flow_nominal = mA_flow_nominal, m2_flow_nominal = mA_flow_nominal, dp1_nominal = 200, dp2_nominal = 200, redeclare package Medium1 = Buildings.Media.Air "Moist air", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
        Placement(transformation(origin = {-62, -14}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(m1_flow_nominal = mW_flow_nominal, m2_flow_nominal = mA_flow_nominal, show_T = true, dp1_nominal = 6000, dp2_nominal = 200, use_Q_flow_nominal = true, Q_flow_nominal = QCoiC_flow_nominal, T_a1_nominal = TWSup_nominal, T_a2_nominal = THeaRecLvg, w_a2_nominal = wHeaRecLvg, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, redeclare package Medium1 = Buildings.Media.Water "Water", redeclare package Medium2 = Buildings.Media.Air "Moist air")  annotation(
        Placement(transformation(origin = {-2, -12}, extent = {{10, 10}, {-10, -10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water", use_m_flow_in = true, T = TWSup_nominal)  annotation(
        Placement(transformation(origin={-16,-104},   extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(nPorts = 1, redeclare package Medium = Buildings.Media.Water "Water")  annotation(
        Placement(transformation(origin = {-40, -52}, extent = {{-10, -10}, {10, 10}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam = "C:/Users/jadhe/OneDrive/Documents/Dymola/Buildings 13.0.0/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos",
        TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,                                                                                                                                                                                                      TDryBul = TOut_nominal, computeWetBulbTemperature = false)  annotation(
        Placement(transformation(origin={-195,81},   extent = {{-15, -13}, {15, 13}})));
  //  /modelica://Buildings/Resources/weatherdata/USA_IL_ChicagoOHare.Intl.AP.725300_TMY3.mos"
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemHxOut(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
        Placement(transformation(origin = {28, -10}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(redeclare package Medium = Buildings.Media.Air "Moist air", m_flow_nominal = mA_flow_nominal)  annotation(
        Placement(transformation(origin = {-28, -3}, extent = {{-8, -9}, {8, 9}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation(
        Placement(transformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-46, 68}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Fluid.Sources.Outside out(redeclare package Medium = Buildings.Media.Air "Moist air", nPorts = 2)  annotation(
        Placement(transformation(origin={-96,36},   extent = {{-10, -10}, {10, 10}})));
      Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoint(k=297.15)
        annotation (Placement(transformation(origin={40,-4},     extent = {{-218, -46}, {-198, -26}})));
      Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
        annotation (Placement(transformation(extent={{106,60},{126,80}})));
      Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
        table={{0,297.15},{43200,297.15},{3600*15,297.15},{3600*24,297.15}},
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
        extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
        annotation (Placement(transformation(origin = {40, -18}, extent = {{-218, 12}, {-198, 32}})));
      Buildings.Controls.OBC.CDL.Reals.PID conPID(
        k= 0.01,
        Ti= 30,
        yMax=2*mW_flow_nominal,
        yMin= 0, reverseActing = false)
        annotation (Placement(transformation(origin = {0, -4}, extent = {{-126, -52}, {-106, -32}})));
  Buildings.Controls.OBC.CDL.Reals.PID conPID1(Ti = 30, k = 0.01, reverseActing = false, yMax = mA_flow_nominal, yMin = 0.01) annotation(
        Placement(transformation(origin = {150, -14}, extent = {{-126, -52}, {-106, -32}})));
    Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
      redeclare package Medium = Buildings.Media.Air "Moist air",
      Q_flow_nominal(displayUnit="kW") =                                                                                                           1000, m_flow_nominal = mA_flow_nominal, dp_nominal = 100)  annotation(
      Placement(transformation(origin = {87, 29}, extent = {{-13, -15}, {13, 15}}, rotation = 90)));
    Buildings.Controls.OBC.CDL.Reals.PID conPID11(
      Ti=30,
      k=0.001,
      reverseActing=true,
      yMax=1,
      yMin=0.01)                                                                                               annotation(
      Placement(transformation(origin = {98, 84}, extent = {{-126, -52}, {-106, -32}})));
  equation
      connect(theCon.port_b, vol.heatPort) annotation(
        Line(points = {{40, 66}, {61, 66}, {61, 86}, {84, 86}}, color = {191, 0, 0}));
      connect(preHea.port, vol.heatPort) annotation(
        Line(points = {{52, 102}, {52, 86}, {84, 86}}, color = {191, 0, 0}));
      connect(Tout_1.port, theCon.port_a) annotation(
        Line(points = {{-2, 86}, {-2, 66}, {20, 66}}, color = {191, 0, 0}));
      connect(fan.port_a, senTemHxOut.port_b) annotation(
        Line(points = {{50, -12}, {44, -12}, {44, -10}, {38, -10}}, color = {0, 127, 255}));
      connect(cooCoi.port_a2, senTemSupAir.port_b) annotation(
        Line(points = {{-12, -6}, {-19, -6}, {-19, -3}, {-20, -3}}, color = {0, 127, 255}));
      connect(cooCoi.port_b2, senTemHxOut.port_a) annotation(
        Line(points = {{8, -6}, {13, -6}, {13, -10}, {18, -10}}, color = {0, 127, 255}));
      connect(cooCoi.port_a1, souWat.ports[1]) annotation(
        Line(points = {{8, -18}, {8, -104}, {-6, -104}}, color = {0, 127, 255}));
      connect(cooCoi.port_b1, sinWat.ports[1]) annotation(
        Line(points = {{-12, -18}, {-26, -18}, {-26, -52}, {-30, -52}}, color = {0, 127, 255}));
      connect(weaDat.weaBus, weaBus) annotation(
        Line(points = {{-180, 81}, {-116, 81}, {-116, 68}, {-46, 68}}, color = {255, 204, 51}, thickness = 0.5));
      connect(Tout_1.T, weaBus.TDryBul) annotation(
        Line(points = {{-24, 86}, {-32, 86}, {-32, 68.05}, {-45.95, 68.05}}, color = {0, 0, 127}));
      connect(hex.port_b1, senTemSupAir.port_a) annotation(
        Line(points = {{-52, -8}, {-36, -8}, {-36, -3}}, color = {0, 127, 255}));
    connect(
        hex.port_a2, vol.ports[1]) annotation (
      Line(points = {{-52, -20}, {-52, 28}, {-12, 28}, {-12, 26}, {56, 26}, {56, 38}, {59, 38}, {59, 76}, {94, 76}}, color = {0, 127, 255}));
      connect(out.ports[1], hex.port_a1) annotation(
        Line(points = {{-86, 36}, {-78, 36}, {-78, -8}, {-72, -8}}, color = {0, 127, 255}));
      connect(hex.port_b2, out.ports[2]) annotation(
        Line(points = {{-72, -20}, {-80, -20}, {-80, 36}, {-86, 36}}, color = {0, 127, 255}));
      connect(weaDat.weaBus, out.weaBus) annotation(
        Line(points = {{-180, 81}, {-116, 81}, {-116, 36}, {-106, 36}}, color = {255, 204, 51}, thickness = 0.5));
      connect(vol.heatPort, temperatureSensor.port) annotation(
        Line(points = {{84, 86}, {95, 86}, {95, 70}, {106, 70}}, color = {191, 0, 0}));
      connect(combiTimeTable.y[1], conPID.u_s) annotation(
        Line(points = {{-157, 4}, {-136, 4}, {-136, -46}, {-128, -46}}, color = {0, 0, 127}));
      connect(temperatureSensor.T, conPID.u_m) annotation(
        Line(points = {{127, 70}, {136, 70}, {136, -128}, {-116, -128}, {-116, -58}}, color = {0, 0, 127}));
      connect(conPID.y, souWat.m_flow_in) annotation(
        Line(points = {{-104, -46}, {-56, -46}, {-56, -96}, {-28, -96}}, color = {0, 0, 127}));
  connect(temperatureSensor.T, conPID1.u_m) annotation(
        Line(points = {{128, 70}, {107.5, 70}, {107.5, 16}, {107, 16}, {107, -76}, {112, -76}, {112, -75}, {50, -75}, {50, -75.5}, {34, -75.5}, {34, -68}}, color = {0, 0, 127}));
  connect(combiTimeTable.y[1], conPID1.u_s) annotation(
        Line(points = {{-157, 4}, {23, 4}, {23, -56}, {22, -56}}, color = {0, 0, 127}));
  connect(conPID1.y, fan.m_flow_in) annotation(
        Line(points = {{46, -56}, {60, -56}, {60, 0}}, color = {0, 0, 127}));
    connect(
        fan.port_b, hea.port_a) annotation (
      Line(points = {{70, -12}, {87, -12}, {87, 16}}, color = {0, 127, 255}));
    connect(
        hea.port_b, vol.ports[2]) annotation (
      Line(points = {{87, 42}, {94, 42}, {94, 76}}, color = {0, 127, 255}));
    connect(
        combiTimeTable.y[1], conPID11.u_s) annotation (
      Line(points = {{-157, 4}, {-30, 4}, {-30, 42}}, color = {0, 0, 127}));
    connect(
        temperatureSensor.T, conPID11.u_m) annotation (
      Line(points = {{128, 70}, {55, 70}, {55, 30}, {2, 30}, {2, 39.5}, {-18, 39.5}, {-18, 30}}, color = {0, 0, 127}));
    connect(
        conPID11.y, hea.u) annotation (
      Line(points = {{-6, 42}, {78, 42}, {78, 14}}, color = {0, 0, 127}));
      annotation(
        experiment(StartTime = 1.5552e+07, StopTime = 1.56384e+07, Tolerance = 1e-06, Interval = 21.6867),
        __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", s = "cvode", variableFilter = ".*"),
        Diagram(coordinateSystem(extent={{-240,-140},{200,120}})),
        Icon(coordinateSystem(extent={{-240,-140},{200,120}})),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=backenddaeinfo,initialization -d=backenddaeinfo");
  end SpaceCooling_Controlled_Demand_PI_Heat;
end SystemLevel;
