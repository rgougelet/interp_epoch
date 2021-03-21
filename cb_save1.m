if ~isfield(EEG.etc, 'wininterp')
		warning('No single-trial channels have been marked for interpolation.')
		return;
end

try
	[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET);
	if isfield(EEG.etc, 'pipeline')
		EEG.etc.pipeline{end+1, :} = 'Single-trial channels marked for interpolation: ';
		EEG.etc.pipeline{end+1, :} = EEG.etc.wininterp;
		EEG.etc.pipeline{end+1, :} = EEG.etc.wn;
		EEG.etc.pipeline{end+1, :} = 'Whole trials marked for rejection: ';
		EEG.etc.pipeline{end+1, :} = EEG.reject.rejmanual;
		EEG.etc.pipeline{end+1, :} = ['Saved as ', EEG.setname, ' to ', EEG.filepath, ' at ', datestr(now)];
		EEG = pop_saveset( EEG, 'savemode', 'resave');
	end
	eeglab redraw;
catch
	disp('Save failed.');
end
