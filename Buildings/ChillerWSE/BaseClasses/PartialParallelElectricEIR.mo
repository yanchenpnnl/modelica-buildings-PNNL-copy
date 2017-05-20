within Buildings.ChillerWSE.BaseClasses;
partial model PartialParallelElectricEIR
  "Partial model for electric chiller parallel"
  extends PartialParallelPlant;

  parameter Modelica.SIunits.Time tau1 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau2 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

 //Advanced
   parameter Medium1.MassFlowRate m1_flow_small(min=0) = 1E-4*abs(m1_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Medium2.MassFlowRate m2_flow_small(min=0) = 1E-4*abs(m2_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium1.AbsolutePressure p1_start = Medium1.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.Temperature T1_start = Medium1.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.MassFraction X1_start[Medium1.nX] = Medium1.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nXi > 0));
  parameter Medium1.ExtraProperty C1_start[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames)=fill(0, Medium1.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));
  parameter Medium1.ExtraProperty C1_nominal[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames) = fill(1E-2, Medium1.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));

  parameter Medium2.AbsolutePressure p2_start = Medium2.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.Temperature T2_start = Medium2.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.MassFraction X2_start[Medium2.nX] = Medium2.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nXi > 0));
  parameter Medium2.ExtraProperty C2_start[Medium2.nC](
    final quantity=Medium2.extraPropertiesNames)=fill(0, Medium2.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));
  parameter Medium2.ExtraProperty C2_nominal[Medium2.nC](
    final quantity=Medium2.extraPropertiesNames) = fill(1E-2, Medium2.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));

  replaceable Buildings.Fluid.Chillers.BaseClasses.PartialElectric chi[n](
    redeclare each replaceable package Medium1 = Medium1,
    redeclare each replaceable package Medium2 = Medium2,
    each final allowFlowReversal1=allowFlowReversal1,
    each final allowFlowReversal2=allowFlowReversal2,
    each final show_T=show_T,
    each final from_dp1=from_dp1,
    each final dp1_nominal=0,
    each final linearizeFlowResistance1=linearizeFlowResistance1,
    each final deltaM1=deltaM1,
    each final from_dp2=from_dp2,
    each final dp2_nominal=0,
    each final linearizeFlowResistance2=linearizeFlowResistance2,
    each final deltaM2=deltaM2,
    each final homotopyInitialization=homotopyInitialization,
    each final m1_flow_nominal=m1_flow_nominal,
    each final m2_flow_nominal=m2_flow_nominal,
    each final m1_flow_small=m1_flow_small,
    each final m2_flow_small=m2_flow_small,
    each final tau1=tau1,
    each final tau2=tau2,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final p1_start=p1_start,
    each final T1_start=T1_start,
    each final X1_start=X1_start,
    each final C1_start=C1_start,
    each final C1_nominal=C1_nominal,
    each final p2_start=p2_start,
    each final T2_start=T2_start,
    each final X2_start=X2_start,
    each final C2_start=C2_start,
    each final C2_nominal=C2_nominal)
    "Identical chiller with number n"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Interfaces.BooleanInput on[n]
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Math.BooleanToReal booToRea[n](
    each final realTrue=1,
    each final realFalse=0)
    "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Interfaces.RealInput TSet
    "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
equation
  for i in 1:n loop
  connect(TSet, chi[i].TSet) annotation (Line(points={{-120,-40},{-90,-40},{-90,
          -3},{-12,-3}}, color={0,0,127}));
  connect(chi[i].port_a1, port_a1) annotation (Line(points={{-10,6},{-40,6},{-40,
          60},{-100,60}}, color={0,127,255}));
  connect(chi[i].port_a2, port_a2) annotation (Line(points={{10,-6},{40,-6},{40,
          -60},{100,-60}}, color={0,127,255}));
  end for;

  connect(chi.port_b2, val2.port_a)
    annotation (Line(points={{-10,-6},{-40,-6},{-40,-22}}, color={0,127,255}));
  connect(chi.port_b1, val1.port_a)
    annotation (Line(points={{10,6},{40,6},{40,22}}, color={0,127,255}));
  connect(booToRea.y, val1.y) annotation (Line(points={{-59,40},{20,40},{20,32},
          {28,32}}, color={0,0,127}));
  connect(on, chi.on) annotation (Line(points={{-120,40},{-90,40},{-90,3},{-12,3}},
        color={255,0,255}));
  connect(on, booToRea.u) annotation (Line(points={{-120,40},{-101,40},{-82,40}},
        color={255,0,255}));
  connect(booToRea.y, val2.y) annotation (Line(points={{-59,40},{-56,40},{-56,-32},
          {-52,-32}}, color={0,0,127}));
end PartialParallelElectricEIR;
