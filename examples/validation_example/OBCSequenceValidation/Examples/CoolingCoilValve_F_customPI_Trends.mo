within OBCSequenceValidation.Examples;
model CoolingCoilValve_F_customPI_Trends
  "Validation model for the cooling coil control subsequence with recorded data trends using a custom controller model"
  extends Modelica.Icons.Example;

  Modelica.Blocks.Sources.CombiTimeTable TOut_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="OA_Temp",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    columns={3},
    fileName=("/home/mg/data/obc_validation_study/trends/OA_Temp.mos"))
    "\"Measured outdoor air temperature\""
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupSetpoint_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="SA_Clg_Stpt",
    columns={3},
    fileName=("/home/mg/data/obc_validation_study/trends/SA_Clg_Stpt.mos"))
    "\"Supply air temperature setpoint\""
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Modelica.Blocks.Sources.CombiTimeTable coolingValveSignal(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="Clg_Coil_Valve",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName="/home/mg/data/obc_validation_study/trends/Clg_Coil_Valve.mos")
                                                                "Output of the cooling valve control subsequence"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));

  Modelica.Blocks.Sources.CombiTimeTable fanFeedback(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="VFD_Fan_Feedback",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=("/home/mg/data/obc_validation_study/trends/VFD_Fan_Feedback.mos"))
    "Fan feedback"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));

  Modelica.Blocks.Sources.CombiTimeTable fanStatus(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    tableName="VFD_Fan_Enable",
    columns={3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=("/home/mg/data/obc_validation_study/trends/VFD_Fan_Enable.mos"))
    "Fan status"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));

  Modelica.Blocks.Sources.CombiTimeTable TSupply_F(
    tableOnFile=true,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    offset={0},
    timeScale(displayUnit="s"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    tableName="Supply_Air_Temp",
    columns={3},
    fileName=("/home/mg/data/obc_validation_study/trends/Supply_Air_Temp.mos"))
                                           "\"Measured supply air temperature\""
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  CoolingCoilValve_F_customPI cooValSta_F(
    reverseAction=false,
    k_p=1/100,
    k_i=0.5/100,
    holdIntError=false,
    TOutCooCut=50) "Cooling valve position control sequence"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain percConv(k=0.01) "Percentage to number converter"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.hours,
    activation=Buildings.Utilities.Plotters.Types.GlobalActivation.always,
    samplePeriod=300,
    fileName="coolingCoilValve_customPI_validationPlots.html")
    "\"Cooling valve control sequence validation\""
    annotation (Placement(transformation(extent={{140,80},{160,100}})));

  Buildings.Utilities.Plotters.Scatter correlation(
    title="OBC cooling valve signal",
    xlabel="Cooling valve signal",
    n=1,
    legend={"OBC cooling valve signal"})     "\"Reference vs. output results\""
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  Buildings.Utilities.Plotters.TimeSeries timSerRes(
    title="Reference and result cooling valve control signal",
    legend={"Cooling valve control signal, OBC","Cooling valve control signal, trended data"},
    n=2)
    "\"Reference and result cooling valve control signal\""
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

  Buildings.Utilities.Plotters.TimeSeries timSerInp(
    title="Input signals",
    legend={"Supply air temperature, [K]","Supply air temperature setpoint, [K]",
        "Outdoor air temperature, [K]"},
    n=3)
     "\"Input signals\""
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(threshold=0.5)
    "Converter to boolean"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain percConv1(k=0.01) "Percentage to number converter"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  FromF FromF1 annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  ToC ToC1 annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  FromF FromF2 annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  ToC ToC2 annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  FromF FromF3 annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  ToC ToC3 annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

equation
  connect(cooValSta_F.yCooVal, timSerRes.y[1])
    annotation (Line(points={{41,30},{50,30},{50,101},{98,101}}, color={0,0,127}));
  connect(cooValSta_F.yCooVal, correlation.y[1])
    annotation (Line(points={{41,30},{70,30},{70,30},{98,30}}, color={0,0,127}));
  connect(percConv.y, timSerRes.y[2])
    annotation (Line(points={{-79,90},{20,90},{20,98},{20,98},{20,
          98},{20,99},{60,99},{98,99}}, color={0,0,127}));
  connect(percConv.y, correlation.x)
    annotation (Line(points={{-79,90},{80,90},{80,22},{98,22}}, color={0,0,127}));
  connect(greEquThr.y, cooValSta_F.uFanSta)
    annotation (Line(points={{-79,-90},{0,-90},{0,20},{19,20}}, color={255,0,255}));
  connect(percConv1.y, cooValSta_F.uFanFee)
    annotation (Line(points={{-79,-60},{-10,-60},{-10,24},{
          -10,24},{-10,-60},{-10,25},{4,25},{19,25}}, color={0,0,127}));
  connect(coolingValveSignal.y[1], percConv.u)
    annotation (Line(points={{-119,90},{-102,90}}, color={0,0,127}));
  connect(TSupply_F.y[1], cooValSta_F.TSup)
    annotation (Line(points={{-119,50},{-30,50},{-30,40},{19,40}}, color={0,0,127}));
  connect(TOut_F.y[1], cooValSta_F.TOut)
    annotation (Line(points={{-119,-20},{-16,-20},{-16,33},{19,33}}, color={0,0,127}));
  connect(fanFeedback.y[1], percConv1.u)
    annotation (Line(points={{-119,-60},{-102,-60}}, color={0,0,127}));
  connect(fanStatus.y[1], greEquThr.u)
    annotation (Line(points={{-119,-90},{-102,-90}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], cooValSta_F.TSupSet)
    annotation (Line(points={{-119,20},{-20,20},{-20,37},{19,37}}, color={0,0,127}));
  connect(TSupply_F.y[1], FromF1.fahrenheit)
    annotation (Line(points={{-119,50},
          {-110,50},{-110,60},{-102,60}}, color={0,0,127}));
  connect(TSupSetpoint_F.y[1], FromF2.fahrenheit)
    annotation (Line(points={{-119,
          20},{-110,20},{-110,30},{-102,30}}, color={0,0,127}));
  connect(TOut_F.y[1], FromF3.fahrenheit)
    annotation (Line(points={{-119,-20},{-110,
          -20},{-110,-10},{-102,-10}}, color={0,0,127}));
  connect(FromF1.kelvin, ToC1.kelvin)
    annotation (Line(points={{-79,60},{-62,60}}, color={0,0,127}));
  connect(FromF2.kelvin, ToC2.kelvin)
    annotation (Line(points={{-79,30},{-62,30}}, color={0,0,127}));
  connect(FromF3.kelvin, ToC3.kelvin)
    annotation (Line(points={{-79,-10},{-62,-10}}, color={0,0,127}));
  connect(ToC1.celsius, timSerInp.y[1])
    annotation (Line(points={{-39,60},{-30,60},{-30,74},{98,74},{98,71.3333}},
                                          color={0,0,127}));
  connect(timSerInp.y[2], ToC2.celsius)
    annotation (Line(points={{98,70},{-26,70},
          {-26,30},{-39,30}}, color={0,0,127}));
  connect(ToC3.celsius, timSerInp.y[3])
    annotation (Line(points={{-39,-10},{-22,-10},{-22,66},{98,66},{98,68.6667}},
                                               color={0,0,127}));
  annotation(experiment(Tolerance=1e-06),startTime = 3733553700, stopTime=3733560900,
  __Dymola_Commands(file="CoolingCoilValve_F_customPI_Trends.mos"
    "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the cooling coil signal subsequence implemented using CDL blocks 
aginst the equivalent OBC implementation as installed in one of the LBNL buildings. 
Data used for the validation are measured input and output trends.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 10, Milica Grahovac<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}}),
        graphics={
        Rectangle(
          extent={{-180,120},{180,-120}},
          lineColor={217,217,217},
          fillColor={217,217,217},
          fillPattern=FillPattern.Solid)}));
end CoolingCoilValve_F_customPI_Trends;