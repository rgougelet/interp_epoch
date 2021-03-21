if ~isfield(EEG.etc, 'wininterp')
		warning('No single-trial channels have been marked for interpolation.')
		return;
end
if ~exist('nEEG','var') || isempty(nEEG)
		warning(['No single-trial channels have been interpolated. ',...
						'Make sure to use the Interpolate menu option after Marking.'])
		return;
end
oldEEG = EEG;
try
% 	EEG = nEEG;
	EEG.saved = 'no';
 	[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET);
	if isfield(EEG.etc, 'pipeline')
		EEG.etc.pipeline{end+1, :} = 'Single-trial channels removed and interpolated: ';
		EEG.etc.pipeline{end+1, :} = EEG.etc.wininterp;
		EEG.etc.pipeline{end+1, :} = EEG.etc.wn;
		EEG.etc.pipeline{end+1, :} = ['Saved as ', EEG.setname, ' to ', EEG.filepath, ' at ', datestr(now)];
	end
	EEG.etc.wininterp = [];
	EEG.etc.wn = [];
% 	evalc('EEG = pop_saveset(EEG, ''filename'', EEG.setname, ''filepath'', EEG.filepath);')
	
	evalc('EEG = pop_saveset( EEG, ''savemode'', ''resave'');');
	clear nEEG oldEEG;
	eeglab redraw;
catch
	EEG = oldEEG;
	clear oldEEG;
	disp('Save failed.');
end