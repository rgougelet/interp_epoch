if ~exist('nEEG','var')
		warning(['No single-trial channels have been interpolated.',...
						'Make sure to use the Interpolate menu option after Marking.'])
		return;
end
if isfield(nEEG.etc, 'pipeline')
	nEEG.etc.pipeline{end+1} = 'Single-trial channels interpolated: ';
	nEEG.etc.pipeline{end+1} = nEEG.etc.wininterp;
end
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, nEEG, CURRENTSET);
EEG.etc.wininterp = [];
eeglab redraw;