within Buildings.Examples.Tutorial.ControlDescriptionLanguage;
model System3 "Open loop model with boiler return temperature control"
  extends Buildings.Examples.Tutorial.ControlDescriptionLanguage.BaseClasses.PartialOpenLoop;

  Controls.BoilerReturn conBoiRet
   "Controller for boiler return water temperature"
    annotation (Placement(transformation(extent={{100,-290},{120,-270}})));
  Controls.OpenLoopSystemOnOff conSysSta
    "Controller that switches the system on and off"
    annotation (Placement(transformation(extent={{-260,-60},{-240,-40}})));
  Controls.OpenLoopRadiatorSupply conRadSup
    "Controller for the mixing valve for the radiator supply water"
    annotation (Placement(transformation(extent={{-200,-160},{-180,-140}})));
  Controls.OpenLoopEquipmentOnOff conEquSta
    "Controller that switches the equipment on and off"
    annotation (Placement(transformation(extent={{-200,-220},{-180,-200}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal radPumCon(
    realTrue=mRad_flow_nominal) "Type conversion for radiator pump signal"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal boiPumCon(
    realTrue=mBoi_flow_nominal) "Type conversion for boiler pump signal"
    annotation (Placement(transformation(extent={{-100,-290},{-80,-270}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal boiSigCon(
   realTrue=1)
    "Type conversion for boiler signal"
    annotation (Placement(transformation(extent={{-100,-260},{-80,-240}})));
equation
  connect(conSysSta.onSys, conEquSta.onSys) annotation (Line(points={{-238,-50},
          {-220,-50},{-220,-216},{-202,-216}}, color={255,0,255}));
  connect(conEquSta.onPum, boiPumCon.u) annotation (Line(points={{-178,-216},{-120,
          -216},{-120,-280},{-102,-280}}, color={255,0,255}));
  connect(radPumCon.u, conEquSta.onPum) annotation (Line(points={{-102,-70},{-120,
          -70},{-120,-216},{-178,-216}}, color={255,0,255}));
  connect(boiSigCon.u, conEquSta.onBoi) annotation (Line(points={{-102,-250},{-108,
          -250},{-108,-204},{-178,-204}}, color={255,0,255}));
  connect(radPumCon.y, pumRad.m_flow_in)
    annotation (Line(points={{-78,-70},{-62,-70}}, color={0,0,127}));
  connect(boiPumCon.y, pumBoi.m_flow_in)
    annotation (Line(points={{-78,-280},{-62,-280}}, color={0,0,127}));
  connect(boiSigCon.y, boi.y) annotation (Line(points={{-78,-250},{34,-250},{34,
          -302},{22,-302}}, color={0,0,127}));
  connect(conRadSup.yVal, valRad.y) annotation (Line(points={{-178,-150},{-62,
          -150}},      color={0,0,127}));
  connect(conEquSta.TBoi, boi.T) annotation (Line(points={{-202,-204},{-240,-204},
          {-240,-302},{-1,-302}}, color={0,0,127}));
  connect(conSysSta.TOut, senTOut.T) annotation (Line(points={{-262,-44},{-280,-44},
          {-280,30},{-298,30}}, color={0,0,127}));
  connect(conRadSup.TRoo, temRoo.T) annotation (Line(points={{-202,-144},{-268,
          -144},{-268,30},{-50,30}},
                               color={0,0,127}));
  connect(conSysSta.TRoo, temRoo.T) annotation (Line(points={{-262,-56},{-268,-56},
          {-268,30},{-50,30}}, color={0,0,127}));
  connect(temRet.T, conBoiRet.TRet)
    annotation (Line(points={{71,-280},{98,-280}}, color={0,0,127}));
  connect(conBoiRet.yVal, valBoi.y) annotation (Line(points={{122,-280},{140,-280},
          {140,-230},{72,-230}}, color={0,0,127}));

  connect(temSup.T, conRadSup.TSup) annotation (Line(points={{-61,-40},{-210,
          -40},{-210,-156},{-202,-156}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
In this step, we added the controller for the boiler return water temperature.
</p>
<h4>Implementation</h4>
<p>
This model was built as follows:
</p>
<ol>
<li>
<p>
First, we copied the controller
<a href=\"modelica://Buildings.Examples.Tutorial.ControlDescriptionLanguage.Controls.OpenLoopBoilerReturn\">
Buildings.Examples.Tutorial.ControlDescriptionLanguage.Controls.OpenLoopBoilerReturn</a>
to create the block
<a href=\"modelica://Buildings.Examples.Tutorial.ControlDescriptionLanguage.Controls.BoilerReturn\">
Buildings.Examples.Tutorial.ControlDescriptionLanguage.Controls.BoilerReturn</a>.
</p>
</li>
<li>
<p>
In this new block, we used a constant output signal
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Sources.Constant\">
Buildings.Controls.OBC.CDL.Continuous.Sources.Constant</a>
and a PID controller
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.LimPID\">
Buildings.Controls.OBC.CDL.Continuous.LimPID</a>,
which we configured as a PI-controller with a p gain of <i>0.1</i>
and a time constant of <i>120</i> seconds, which is about the time it takes to open
and close a valve. As the control error is in Kelvin, which is typically of the order of <i>1</i>
to <i>10</i>, there is no need to normalize the control input. (If pressure were used, it would make sense
to divide the measured signal and the set point so that the control error is usually of the order of one,
which simplifies the tuning.)
</p>
</li>
<li>
<p>
To allow this controller to be tuned, we exposed at the top-level the parameters
for the set point temperature and the control gains.
</p>
</li>
</ol>
<p>
Simulating the system will show that the valve is controlled to maintain a return water temperature
of at least <i>60</i>&circ;C as shown below.
</p>
<p align=\"center\">
<img alt=\"Open loop temperatures.\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/ControlDescriptionLanguage/System3/TemperaturesValve.png\" border=\"1\"/>
</p>
</html>",
revisions="<html>
<ul>
<li>
February 18, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/ControlDescriptionLanguage/System3.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end System3;
