% todo: convert to function that works like EEG = cb_f_updatemarks(EEG)?
if exist('TMPREJ', 'var') && ~isempty(TMPREJ)
  EEG.etc.wininterp = unique(sortrows(TMPREJ,1), 'rows');
end

% EEG = update_wn_with_wininterp(EEG);
EEG = update_rejmanual_with_wininterp(EEG);

disp('Channels successfully marked for single-trial interpolation.');
disp('Be sure to actually perform the interpolation using the Interpolate plugin menu option.');