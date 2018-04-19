within OBCSequenceValidation.Validation;
model HeatingCoilValve_ValidationWithB33Data
  "Validation model for a system with heating, cooling and hot water"
  extends Modelica.Icons.Example;

  parameter Real TOutHeaCut(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 293.15
    "Upper outdoor air temperature limit for enabling heating (68 F)";

  parameter Real TSup(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 289
    "Supply air temperature";

  parameter Real TSupSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 294.261
    "Supply air temperature setpoint";

  parameter Real TSatMinLowLim(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 277.5944
    "Minimum supply air temperature for defining the lower limit of the valve position (40 F)"
    annotation(Evaluate=true);

  parameter Real TSatMaxLowLim(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 280.3722
    "Maximum supply air temperature for defining the lower limit of the valve position (45 F)"
    annotation(Evaluate=true);

  parameter Real LowTSupSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 279
    "Fictive low supply air temeprature setpoint to check the limiter functionality"
    annotation(Evaluate=true);

// Tests disable if supply fan is off
  OBCSequenceValidation.HeatingCoilValve heaValSta
    "Heating coil controll sequence as implemented in LBNL 33-AHU-02 (Roof)"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

// Tests disable if it is warm outside

// Tests controler normal operation when supply air temperature is above limiter values

// Tests controler operation when supply air temperature is within limiter values

  Buildings.Utilities.Plotters.Scatter sca
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Utilities.Plotters.TimeSeries timSer
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
    fileName=plots.html,
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.hours,
    activation=Buildings.Utilities.Plotters.Types.GlobalActivation.always,
    samplePeriod=1) "\"Plots for the validation with B33-AHU-2 data\""
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable refTOut(smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.LinearSegments,
      timeScale=1) "\"Reads measured outdoor air temperature data\""
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timeTable1
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timeTable2
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
  annotation(experiment(Tolerance=1e-06, StopTime=31536000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/?/?/?.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates the heating coil signal subsequence implemented using CDL blocks 
aginst the equivalent OBC implementation as installed in LBNL B33 AHU-2. Data used for the
validation are measured sequence input and output timeseries.
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}})));
end HeatingCoilValve_ValidationWithB33Data;
