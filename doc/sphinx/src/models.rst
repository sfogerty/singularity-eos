.. _models:

EOS Models
===========

The mathematical descriptions of these models are presented below while the
details of using them is presented in the description of the 
:doc:`EOS API <using-eos>`.

EOS Primer
----------

An equation of state (EOS) is a constituitive model that generally relates
thermodynamic quantities such as pressure, temperature, density, internal
energy, free energy, and entropy consistent with the constraints of equillibrium
thermodynamics.

``singularity-eos`` contains a number of equations of state that are most useful
in hydrodynamics codes. All of the equations of state presented here are
considered "complete" equations of state in the sense that they contain all the
information needed to derive a given thermodynamic quantity. However, not all
variables are exposed since the emphasis is on only those that are needed for
hydrodynamics codes. An incomplete equation of state is often sufficient for
pure hydrodynamics since it can relate pressure to a given energy-density state,
but it is missing information that relates the energy to temperature (which in
turn provides a means to calculate entropy).

An excellent resource on equations of state in the context of hydrodynamics is
the seminal work from `Menikoff and Plohr`_. In particular, Appendix A contains
a number of thermodynamic relationships that can be useful for computing
additional quantities from those output in ``singularity-eos``.

.. _Menikoff and Plohr: https://doi.org/10.1103/RevModPhys.61.75

The Mie-Gruneisen form
````````````````````````

Many of the following equations of state are considered to be of
the "Mie-Gruneisen form", which has many implications but for our purposes
means that the general form of the EOS is

.. math::

    P - P_\mathrm{ref} = \rho \Gamma(\rho) (e - e_\mathrm{ref})

where 'ref' denotes quantities along some reference curve, :math:`P` is the
pressure, :math:`\rho` is the density, :math:`\Gamma` is the Gruneisen
parameter, and :math:`e` is the specific internal energy. In this sense, an EOS
of this form uses the Gruneisen parameter to describe the pressure behavior of
the EOS away from the reference curve. Coupled with a relationship between
energy and temperature (sometimes as simple as a constant heat capacity), the
complete equation of state can be constructed.

To some degree it is the complexity of the reference state and the heat
capacity that will determine an EOS's ability to capture the complex behavior of
a material. At the simplest level, the ideal gas EOS uses a reference state at
zero pressure and energy, while more complex equations of state such as the
Davis EOS use the material's isentrope. In ths way, the reference curve
indicates the conditions under which you can expect the EOS to represent the
intended behavior.

Nomenclature
---------------------

The EOS models in ``singularity-eos`` are defined for the following sets of
dependent and independent variables through various member functions described
in the :doc:`EOS API <using-eos>`.

+--------------------------+----------------------+--------------------------+
| Function                 | Dependent Variable   | Independent Variables    |
+==========================+======================+==========================+
| :math:`T(\rho, e)`       | Temperature          | Density, Internal Energy |
+--------------------------+----------------------+                          |
| :math:`P(\rho, e)`       | Pressure             |                          |
+--------------------------+----------------------+--------------------------+
| :math:`e(\rho, T)`       | Internal Energy      | Density, Temperature     |
+--------------------------+----------------------+                          |
| :math:`P(\rho, T)`       | Pressure             |                          |
+--------------------------+----------------------+--------------------------+
| :math:`\rho(P, T)`       | Density              | Pressure, Temperature    |
+--------------------------+----------------------+                          |
| :math:`e(P, T)`          | Internal Energy      |                          |
+--------------------------+----------------------+--------------------------+
| :math:`C_V(\rho, T)`     | Constant Volume      | Density, Temperature     |
+--------------------------+ Specific Heat        +--------------------------+
| :math:`C_V(\rho, e)`     | Capacity             | Density, Internal Energy |
+--------------------------+----------------------+--------------------------+
| :math:`B_S(\rho, T)`     | Isentropic Bulk      | Density, Temperature     |
+--------------------------+ Modulus              +--------------------------+
| :math:`B_S(\rho, e)`     |                      | Density, Internal Energy |
+--------------------------+----------------------+--------------------------+
| :math:`\Gamma(\rho, T)`  | Gruneisen Parameter  | Density, Temperature     |
+--------------------------+                      +--------------------------+
| :math:`\Gamma(\rho, e)`  |                      | Density, Internal Energy |
+--------------------------+----------------------+--------------------------+

A point of note is that "specific" implies that the quantity is intensive on a
per unit mass basis. It should be assumed that the internal energy is *always*
specific since we are working in terms of density (the inverse of specific
volume).

Disambiguation
````````````````

Gruneisen Parameter
'''''''''''''''''''
In this description of the EOS models, we use :math:`\Gamma` to represent the
Gruneisen coeficient since this is the most commonly-used symbol in the
context of Mie-Gruneisen equations of state. This should be differentiated from

 .. math::

    \gamma := \frac{C_P}{C_V} = \frac{B_S}{B_T}
 
though, which is the adiabatic exponent. Here :math:`C_P` is the specific heat
capacity at constant *pressure* and :math:`B_T` is the *isothermal* bulk
modulus.

Units and conversions
---------------------

The default units for ``singularity-eos`` are cgs which results in the following
units for thermodynamic quantities:

+--------------+------------------+---------------------------------------+-----------------------+
|Quantity      | Default Units    | cgµ conversion                        | mm-mg-µs conversion   |
+==============+==================+=======================================+=======================+
|:math:`P`     | µbar             | 10\ :sup:`-12` Mbar                   | 10\ :sup:`-10` GPa    |
+--------------+------------------+---------------------------------------+-----------------------+
|:math:`\rho`  | g/cm\ :sup:`3`   | 1                                     | 1 mg/mm\ :sup:`3`     |
+--------------+------------------+---------------------------------------+-----------------------+
|:math:`e`     | erg/g            | 10\ :sup:`-12` Terg/g                 | 10\ :sup:`-10` J/mg   |
+--------------+------------------+---------------------------------------+-----------------------+
|:math:`T`     | K                | 1                                     | 1                     |
+--------------+------------------+---------------------------------------+-----------------------+
|:math:`C_V`   | erg/g/K          | 10\ :sup:`-12` Terg/g/K               | 10\ :sup:`-10` J/mg/K |
+--------------+------------------+---------------------------------------+-----------------------+
|:math:`B_S`   | µbar             | 10\ :sup:`-12` Mbar                   | 10\ :sup:`-10` GPa    |
+--------------+------------------+---------------------------------------+-----------------------+
|:math:`\Gamma`| unitless         | --                                    | --                    |
+--------------+------------------+---------------------------------------+-----------------------+

Note: some temperatures are measured in eV for which the conversion is
8.617333262e-05 eV/K.

Sesame units are equivalent to the mm-mg-µs unit system.

Implemented EOS models
----------------------


Ideal Gas
`````````

The ideal gas (aka perfect or gamma-law gas) model in ``singularity-eos`` takes
the form

.. math::

    P = \Gamma \rho e

.. math::

    e = C_V T,

where quantities are defined in the :ref:`nomenclature <Nomenclature>` section.

The settable parameters are the Gruneisen parameter and specific heat capacity.


Although this differs from the traditional representation of the ideal gas law
as :math:`P\tilde{V} = RT`, the forms are equivalent by recognizing that
:math:`\Gamma = \frac{R}{\tilde{C_V}}` where :math:`R` is the ideal gas constant
in units of energy per mole per Kelvin and :math:`\tilde{C_\mathrm{V}}` is the
*molar* heat capacity, relatable to the *specific* heat capacity through the
molecular weight of the gas. Since :math:`\tilde{C_\mathrm{V}} = \frac{5}{2} R`
for a diatomic ideal gas, the corresponding Gruneisen parameter should be 0.4.

A common point of confusion is :math:`\Gamma` versus :math:`\gamma` with the
latter being the adiabatic exponent. For an ideal gas, they are related through

.. math::

    \Gamma = \gamma - 1

Gruneisen EOS
`````````````

One of the most commonly-used EOS to represent solids is the Steinberg variation
of the Mie-Gruneisen EOS, often just shortened to "Gruneisen" EOS. This EOS
uses the Hugoniot as the reference curve and thus is extremly powerful because
the basic shock response of a material can be modeled using minimal parameters.

The pressure follows the traditional Mie-Gruneisen form,

.. math::

    P(\rho, e) = P_H(\rho) + \rho\Gamma(\rho) \left(e - e_H(\rho) \right),

Here the subscript :math:`H` is a reminder that the reference curve is a
Hugoniot. Other quantities are defined in the :ref:`nomenclature <Nomenclature>`
section.

The above is an incomplete equation of state because it only relates the
pressure to the density and energy, the minimum required in a solution to the
Euler equations. To complete the EOS and determine the temperature, a constant
heat capacity is assumed so that

.. math::

    T(\rho, e) = \frac{e}{C_V} + T_0

The user should note that this implies that :math:`e=0` at the reference
temperature, :math:`T_0`. Given this simple relationship, the user should
treat the temperature from this EOS as only a rough estimate.

The Grunesien parameter is given by

.. math::

    \Gamma(\rho) =
      \begin{cases}
        \Gamma_0                                          & \rho < \rho_0 \\
        \Gamma_0 \frac{\rho_0}{\rho} 
           + b(1 - \frac{\rho_0}{\rho})                   & \rho >= \rho_0
      \end{cases}

and when the unitless user parameter :math:`b=0`, this ensures the the Gruneisen
parameter is of a form where :math:`\rho\Gamma =` constant in compression.

The reference pressure along the Hugoniot is determined by

.. math::

    P_H(\rho) = \rho_0 c_0^2 \mu
      \begin{cases}
        1                                                 & \rho < \rho_0 \\
        \frac{1 + \left(1 - \frac{1}{2}\Gamma_0 \right)\mu - \frac{b}{2} \mu^2}
          {\left(1 - (s_1 - 1)\mu + s_2 \frac{\mu^2}{1 + \mu}
            - s_3 \frac{\mu^3}{(1+\mu)^2} \right)^2}      & \rho > \rho_0
      \end{cases}

where :math:`c_0`, :math:`s_1`, :math:`s_2`, and :math:`s_3` are fitting
paramters. The units of :math:`c_0` are velocity while the rest are unitless.

Note that similar implementations may have subtly different definitions for the
:math:`s_i` coefficients and care must be taken to use the correct values. Since
:math:`s_2` and `s_3` are unitless for example, these parameters would not
directly correspond to coefficients in a polynomial fit of the shock velocity to
the particle velocity.

JWL EOS
````````

The Jones-Wilkins-Lee (JWL) EOS is used mainly for detonation products of high
explosives. Similar to the other EOS here, the JWL EOS can be written in a
Mie-Gruneisen form as

.. math::

    P(\rho, e) = P_S(\rho) + \rho w (e - e_S(\rho))

where the reference curve is an isentrope of the form

.. math::

    P_S(\rho) = A \mathrm{e}^{-R_1 \eta} + B \mathrm{e}^{-R_2 \eta}

.. math::

    e_S(\rho) = \frac{A}{\rho_0 R_1} \mathrm{e}^{-R_1 \eta}
                + \frac{B}{\rho_0 R_2} \mathrm{e}^{-R_2 \eta}.

Here :math:`\eta = \frac{\rho_0}{\rho}` and :math:`R_1`, :math:`R_2`, :math:`A`,
:math:`B`, and :math:`w` are constants particular to the material. Note that the
parameter :math:`w` is simply the Gruneisen parameter and is assumed constant
for the EOS (which is fairly reasonable since the detonation products are
gasses).

Finally, to complete the EOS the energy is related to the temperature by

.. math::

    e = e_S(\rho) + C_V T

where :math:`C_V` is the constant volume specific heat capacity.


Davis EOS
`````````

The Davis reactants and products EOS are both of Mie-Gruneisen forms that use
isentropes for the reference curves. The equations of state are typically used
to represent high explosives and their detonation products and the reference
curves are calibrated to several sets of experimental data.

For both the reactants and products EOS, the pressure and energy take the forms

.. math::

    P(\rho, e) = P_S(\rho) + \rho\Gamma(\rho) \left(e - e_S(\rho) \right)

.. math::

    e(\rho, P) = e_S(\rho) + \frac{1}{\rho \Gamma(\rho)} \left(P - P_S(\rho)
      \right),

where the subscript :math:`S` denotes quantities along the reference isentrope
and other quantities are defined in the :ref:`nomenclature <Nomenclature>`
section.

Davis Reactants EOS
'''''''''''''''''''

The Davis reactants EOS uses an isentrope passing through a reference state
and assumes that the heat capacity varies linearly with entropy such that

.. math::

    C_V = C_{V,0} + \alpha(S - S_0),

where subscript :math:`0` refers to the reference state and :math:`\alpha` is
a dimensionless constant specified by the user. 

The :math:`e(\rho, P)` lookup is quite awkward, so the energy is
more-conveniently cast in terms of termperature such that

.. math::

    e(\rho, T) = e_S(\rho) + \frac{C_{V,0} T_S(\rho)}{1 + \alpha}
      \left( \left(\frac{T}{T_S(\rho)} \right)^{1 + \alpha} - 1 \right),

which can easily be inverted to find :math:`T(\rho, e)`.

The Gruneisen parameter takes on a linear form such that

.. math::

    \Gamma(\rho) = \Gamma_0 +
      \begin{cases}
        0                 & \rho < \rho_0 \\
        Zy                & \rho >= \rho_0
      \end{cases}

where :math:`Z` and :math:`y` are dimensionless parameters.

Finally, the pressure, energy, and temperature along the isentrope are given by

.. math::

    P_S(\rho) = P_0 + \frac{\rho_0 A^2}{4B}
      \begin{cases}
        \mathrm{e} \left( 4By \right) -1   & \rho < \rho_0 \\
        \sum\limits_{j=1}^3 \frac{(4By)^j}{j!} + C\frac{(4By)^4}{4!}
            + \frac{y^2}{(1-y)^4}    & \rho >= \rho0
      \end{cases}

.. math::

    e_S(\rho) = e_0 + \int\limits_{\rho_0}^{\rho}
      \frac{P_S(\bar{\rho})}{\bar{\rho^2}}~\mathrm{d}\bar{\rho}

.. math::

    T_S(\rho)  = T_0
      \begin{cases}
        \left(\frac{\rho}{\rho_0} \right)^{\Gamma_0}  & \rho < \rho_0 \\
        \mathrm{e} \left( -Zy \right) \left(\frac{\rho}{\rho_0} \right)^{\Gamma_0 + Z}
                                                      & \rho >= \rho_0
      \end{cases}

where :math:`A`, :math:`B`, :math:`C`, :math:`y`, and :math:`Z` are all
user-settable parameters and again quantities with a subcript of :math:`0`
refer to the reference state. The variable :math:`\bar{\rho}` is simply an
integration variable. The parameter :math:`C` is especially useful for ensuring
that the high-pressure portion of the shock Hugoniot does not cross that of the
products.

The settable parameters are the dimensionless parameters listed above as well as
the pressure, density, temperature, energy, Gruneisen parameter, and constant
volume specific heat capacity at the reference state.


Davis Products EOS
'''''''''''''''''''

The Davis products EOS is created from the reference isentrope passing through
the CJ state of the high explosive along with a constant heat capacity. The
constant heat capacity leads to the energy being a simple funciton of the
temperature deviation from the reference isentrope such that

.. math::
    
    e(\rho, T) = e_S(\rho) + C_{V,0} (T - T_S(\rho)).

The Gruneisen parameter is given by

.. math::

    \Gamma(\rho) = k - 1 + (1-b) F(\rho)

where :math:`b` is a user-settable dimensionless parameter and :math:`F(\rho)`
is given by

.. math::

    F(\rho) = \frac{2a (\rho V_{\mathrm{C}})^n}{(\rho V_{\mathrm{C}})^{-n}
      + (\rho V_{\mathrm{C}})^n}.

Here the calibration parameters :math:`a` and :math:`n` are dimensionless while
:math:`V_{\mathrm{C}}` is given in units of specific volume.

Finally, the pressure, energy, and temperature along the isentrope are given by

.. math::
    
    P_S(\rho) = P_{\mathrm{C}} G(\rho) \frac{k - 1 + F(\rho)}{k - 1 + a}

.. math::

    e_S(\rho) = e_{\mathrm{C}} G(\rho) \frac{1}{\rho V_{\mathrm{C}}}

.. math::

    T_S(\rho) = T_{\mathrm{C}} G(\rho) \frac{1}{(\rho V_{\mathrm{C}})^{ba + 1}}

where

.. math::

    G(\rho) = \frac{
      \left( \frac{1}{2}(\rho V_{\mathrm{C}})^{-n} 
        + \frac{1}{2}(\rho V_{\mathrm{C}})^n \right)^{a/n}}
      {(\rho V_{\mathrm{C}})^{-(k+a)}}

and

.. math::

    e_{\mathrm{C}} = \frac{P_{\mathrm{C}} V_{\mathrm{C}}}{k - 1 + a}.

Here, there are four dimensionless parameters that are settable by the user,
:math:`a`, :math:`b`, :math:`k`, and :math:`n`, while :math:`P_\mathrm{C}`,
:math:`e_\mathrm{C}`, :math:`V_\mathrm{C}` and :math:`T_\mathrm{C}` are tuning
parameters with units related to their non-subscripted counterparts.


Spiner EOS
````````````

Spiner EOS is a tabulated reader for the `Sesame`_ database of material
equations of state. Materials include things like water, dry air,
iron, or steel. This model comes in two flavors:
``SpinerEOSDependsRhoT`` and ``SpinerEOSDependsRhoSie``. The former
tabulates all quantities of interest in terms of density and
temperature. The latter also includes tables in terms of density and
specific internal energy.

Tabulating in terms of density and pressure means that computing,
e.g., pressure in terms of density and internal energy requires
solving the equation:

.. math::

   e_0 = e(\rho, T)

for temperature :math:`T` given density :math:`\rho` and specific
internal energy :math:`e_0`. This is in general not closed
algebraically and must be solved using a
root-find. ``SpinerEOSDependsRhoT`` performs this root find in-line,
and the result is performant, thanks to library's ability to take and
cache initial guesses. ``SpinerEOSDependsRhoSie`` circumvents this
issue by tabulating in terms of both specific internal energy and
temperature.

Both models use (approximately) log-linear interpolation on a grid
that is (approximately) uniformly spaced on a log scale. Thermodynamic
derivatives are tabulated and interpolated, rather than computed from
the interpolating function. This approach allows for significantly
higher fidelity approximations of these derivatives.

Stellar Collapse EOS
````````````````````

This model provides finite temperature nuclear equations of state
suitable for core collapse supernova and compact object (such as
neutron star) simulations. These models assume nuclear statistical
equilibrium (NSE). It reads tabulated data in the `Stellar Collapse`_
format, as first presented by `O'Connor and Ott`_.

Like ``SpinerEOSDependsRhoT``, ``StellarCollapse`` tabulateds all
quantities in terms of density and temperature on a logarithmically
spaced grid. And similarly, it requires an in-line root-find to
compute quantities in terms of density and specific internal
energy. Unlike most of the other models in ``singularity-eos``,
``StellarCollapse`` also depends on a third quantity, the electron
fraction,

.. math::

   Y_e = \frac{n_e}{n_p + n_n}

which measures the number fraction of electrons to baryons. Symmetric
matter has a :math:`Y_e` of 0.5, while cold neutron stars, have a
:math:`Y_e` approximately less than 0.1.

As with ``SpinerEOSDependsRhoT``, the Stellar Collapse tables tabulate
thermodynamic derivatives separately, rather than reconstruct them
from interpolants. However, the tabulated values can contain
artifacts, such as unphysical spikes. To mitigate this issue, the
thermodynamic derivatives are cleaned via a `median filter`_. The bulk
modulus is then recomputed from these thermodynamic derivatives via:

.. math::

   B_S(\rho, T) = \rho \left(\frac{\partial P}{\partial\rho}\right)_e + \frac{P}{\rho} \left(\frac{\partial P}{\partial e}\right)_\rho

Note that ``StellarCollapse`` is a relativistic model, and thus the
sound speed is given by

.. math::

   c_s^2 = \frac{B_S}{w}

where :math:`w = \rho h` for specific entalpy :math:`h` is the
enthalpy by volume, rather than the density :math:`rho`. This ensures
the sound speed is bounded from above by the speed of light.

.. _Stellar Collapse: https://stellarcollapse.org/equationofstate.html

.. _O'connor and Ott`: https://doi.org/10.1088/0264-9381/27/11/114103

.. _median filter: https://en.wikipedia.org/wiki/Median_filter

EOSPAC EOS
````````````

This is a striaghtforward wrapper of the `EOSPAC`_ library for the
`Sesame`_ database.

.. _Sesame: https://www.lanl.gov/org/ddste/aldsc/theoretical/physics-chemistry-materials/sesame-database.php

.. _EOSPAC: https://laws.lanl.gov/projects/data/eos/eospacReleases.php
