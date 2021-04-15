function cb_f_plot(nEEG)

if ~isfield(nEEG.etc,'wininterp') || isempty(nEEG.etc.wininterp)
		warning(['No single-trial channels have been marked for interpolation.',...
					'Make sure to use the Mark menu option and then the Interpolate option after marking.'])
		return;
end
if ~isfield(nEEG.etc,'interp') || isempty(nEEG.etc.interp)
		warning('No single-trial channels have been interpolated. Make sure to use the Interpolate menu option after Marking.')
		return;
end

oldEEG = nEEG;
for  interp_i = 1:length(nEEG.etc.interp)
  interp = nEEG.etc.interp(interp_i,:);
  oldEEG.data(interp{2},:,interp{1}) = interp{4};
end

if ~isempty(nEEG.reject.rejmanual)
	wj = nEEG.etc.wininterp;
	wj(wj(:,5)~=.783,:) = [];

	ie_eegplot(nEEG.data,...
			'data2', oldEEG.data,...
			'events', nEEG.event,...
			'srate', nEEG.srate,...
			'limits', [nEEG.xmin nEEG.xmax]*1000,...
			'winrej', wj,...
			'wincolor', [1 1 .783],...
			'title', ['Plot before (red) and after (blue) interpolation results -- ', nEEG.setname],...
			'eloc_file', nEEG.chanlocs);
else
	ie_eegplot(nEEG.data,...
			'data2', oldEEG.data,...
			'events', nEEG.event,...
			'srate', nEEG.srate,...
			'limits', [nEEG.xmin nEEG.xmax]*1000,...
			'title', ['Plot before (red) and after (blue) interpolation results -- ', nEEG.setname],...
			'eloc_file', nEEG.chanlocs);
end