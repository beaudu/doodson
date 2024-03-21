function X=doodson(w)
%DOODSON Doodson tidal wave components
%	DOODSON(WAVE) displays the wave period (in days) for wave symbol WAVE.
%	WAVE must be a string or a cell of strings.
%
%	X=DOODSON(WAVE) returns a structure containing, for the tidal wave
%	symbol(s) WAVE, the following fields:
%	    doodson: vector of the 6 Doodson arguments
%	     symbol: wave symbol string (Darwin's notation)
%	       name: wave long name description
%	     period: wave period (in days)
%
%	DOODSON without any input argument uses or displays all available waves.
%
% References:
%    Agnew D.C. (2007), Earth Tides, in « Treatise on Geophysics: Geodesy »,
%        T. A. Herring Ed., Elsevier, New York.
%    Sulzbach, R., K. Balidakis, H. Dobslaw, M. Thomas (2022): TiME22: Periodic 
%        Disturbances of the Terrestrial Gravity Potential Induced by Oceanic
%        and Atmospheric Tides. GFZ Data Services. https://doi.org/10.5880/GFZ.1.3.2022.006
%
%	Author: François Beauducel <beauducel@ipgp.fr>
%	Created: 2014-05-22
%	Updated: 2024-03-21

%	Copyright (c) 2014-2024, François Beauducel, covered by BSD License.
%	All rights reserved.
%
%	Redistribution and use in source and binary forms, with or without
%	modification, are permitted provided that the following conditions are
%	met:
%
%	   * Redistributions of source code must retain the above copyright
%	     notice, this list of conditions and the following disclaimer.
%	   * Redistributions in binary form must reproduce the above copyright
%	     notice, this list of conditions and the following disclaimer in
%	     the documentation and/or other materials provided with the distribution
%
%	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
%	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
%	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
%	ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
%	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
%	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
%	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
%	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
%	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
%	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
%	POSSIBILITY OF SUCH DAMAGE.

ww = { ...
 055.565 'N'    'Lunar Saros';
 056.554 'Sa'   'Solar annual';
 057.555 'Ssa'  'Solar semiannual';
 058.554 'Sta'  '';
 063.655 'MSm'  '';
 065.455 'Mm'   'Lunar monthly';
 065.555 '3Mm'  ''
 073.555 'MSf'  'Lunisolar synodic fortnightly';
 075.555 'Mf'   'Lunisolar fortnightly';
 085.455 'Mtm'  '';
 125.755 '2Q1'  'Larger elliptic diurnal';
 127.555 'sig1' ''
 135.555 '3Q1'  ''
 135.655 'Q1'   'Larger lunar elliptic diurnal';
 137.455 'rho1' 'Larger lunar evectional diurnal';
 145.555 'O1'   'Principal lunar declinational';
 145.655 '3O1'  '';
 147.555 'tau1' '';
 155.555 'M1'   'Smaller lunar elliptic diurnal';
 155.655 'NO1'  '';
 157.455 'chi1' '';
 162.556 'pi1'  '';
 163.555 'P1'   'Principal solar declination';
 164.555 'S1'   'Solar diurnal (oceanic)';
 164.556 'S1a'  'Solar diurnal (atmospheric)';
 165.555 'K1'   'Lunisolar diurnal';
 166.554 'psi1' '';
 167.555 'phi1' '';
 173.655 'tet1' '';
 175.455 'J1'   'Smaller lunar elliptic diurnal';
 175.555 '3J1'  '';
 183.555 'SO1'  '';
 185.555 'OO1'  'Lunar diurnal';
 227.655 'eps2' '';
 235.655 '32N2' '';
 235.755 '2N2'  'Lunar elliptical semidiurnal second-order';
 237.555 'MU2'  'Variational';
 245.555 '3N2'  '';
 245.655 'N2'   'Larger lunar elliptic semidiurnal';
 247.455 'nu2'  'Larger lunar evectional';
 255.555 'M2'   'Principal lunar semidiurnal';
 255.655 '3M2'  '';
 263.655 'lam2' 'Smaller lunar evectional';
 265.455 'L2'   'Smaller lunar elliptic semidiurnal';
 265.555 '3L2'  '';
 272.556 'T2'   'Larger solar elliptic';
 273.555 'S2'   'Principal solar semidiurnal';
 274.555 'R2'   'Smaller solar elliptic';
 275.555 'K2'   'Lunisolar semidiurnal';
 285.455 'eta2' '';
 291.555 '2SM2' 'Shallow water semidiurnal';
 355.555 'M3'   'Lunar terdiurnal';
 345.555 '2MK3' 'Shallow water terdiurnal';
 345.655 '3MN3' '';
 365.555 'MK3'  'Shallow water terdiurnal';
 381.555 'T3'   '';
 382.555 'S3'   'Solar terdiurnal';
 383.555 'R3'   '';
 445.655 'MN4'  'Shallow water quarter diurnal';
 455.555 'M4'   'Shallow water overtides of principal lunar';
 473.555 'MS4'  'Shallow water quarter diurnal';
 491.555 'S4'   'Shallow water overtides of principal solar';
 655.555 'M6'   'Shallow water overtides of principal lunar';
 855.555 'M8'   'Shallow water eighth diurnal';
};

% Speed (in cycle/day) for various Earth-Moon-Sun astronomical attributes
ems = [ ...
  1.03505;      %  T: Lunar day.
 27.3217;       %  s: Moon's longitude: tropical month
365.2422;       %  h: Sun's longitude: solar year
365.25*8.847;   %  p: Lunar perigee
365.25*18.613;  %  N: Lunar node
365.25*20941;   % pp: Lunar perigee (precession of the perihelion)
]';

if nargin == 0
	k = 1:size(ww,1);
else
	if ischar(w)
		w = cellstr(w);
	elseif iscell(w) && ~all(cellfun(@ischar,w))
		error('WAVE argument must be a string or cell array of strings.')
	end
	[i,j] = ismember(upper(w),upper(ww(:,2)));
	if any(i==0)
		warning('%d wave name(s) are unknown.',sum(~i))
	end
	if any(j)
		k = j(j>0);
	else
		error('unknown wave name.')
	end
end

% builts Doodson numbers from the standard notation
dd = reshape(sprintf('%06d',fix(cat(1,ww{k,1})*1000)) - '0',6,length(k))';
dd(:,2:6) = dd(:,2:6) - 5;	% first argument is not concerned

% computes the period of waves
p = 1./sum(dd./repmat(ems,length(k),1),2);

if nargout > 0
	X.symbol = ww(k,2);
	X.name = ww(k,3);
	X.doodson = dd;
	X.period = p;
else
	for n = 1:length(k)
		fprintf('%5s: %07.3f, %g day%s\n',ww{k(n),2},ww{k(n),1},p(n),repmat('s',p(n)>=2));
	end
end
