if ~isfield(EEG.etc, 'wininterp')
		warning('No single-trial channels have been marked for interpolation.')
		return;
end
if (~isfield(EEG.etc,'interp')) 
		warning(['No single-trial channels have been interpolated. ',...
						'Make sure to use the Interpolate menu option after Marking.'])
		return;
end
oldEEG = EEG;
try
	EEG.saved = 'no';
 	[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET);
	EEG.etc.wininterp = [];
	EEG.etc.wn = [];
 	EEG.etc.interp = [];

	evalc('EEG = pop_saveset( EEG, ''savemode'', ''resave'');');
	clear oldEEG;
	eeglab redraw;
catch
	EEG = oldEEG;
	clear oldEEG;
	disp('Save failed.');
end