% restart
close all; clear; clc;

% definitions
params.base_path = 'C:/users/f002r5k/Desktop/20210618-synovial/csv';
params.sample_id.control = {'ctrl_001', 'ctrl_002', 'ctrl_003', 'ctrl_004'};
params.sample_id.aseptic = {'sf_057', 'sf_088', 'sf_086'};
params.sample_id.septic  = {'sf_021', 'sj_007', 'sj_014'};
params.excitation = [275, 365, 436, 460,490, 532];

% create tiled layout
figure;
set(gcf,'Position',[2.066000e+02 1.018000e+02 1.105600e+03 6.664000e+02]);
tl = tiledlayout(length(params.excitation),3);
tl.Padding = 'none';
tl.TileSpacing = 'tight';

% iterate over excitation wavelengths
axrow = [];
for excitationIdx = 1:length(params.excitation)
    thisExcitation = params.excitation(excitationIdx);
    thisControl = [];
    axrow(excitationIdx).ah = [];
    for colIdx = 1:3
        switch(colIdx)
            case 1
                sample_id = params.sample_id.control;
            case 2
                sample_id = params.sample_id.aseptic;
            case 3
                sample_id = params.sample_id.septic;
        end
        
        % plot data from each file
        thisTileIdx = 3*(excitationIdx-1)+colIdx;
        ax = nexttile(thisTileIdx);
        axrow(excitationIdx).ah(end+1) = ax;
        hold on; grid on;
        leg_strings = {};
        leg_plots = [];
        for fileIdx = 1:length(sample_id)
            this_file = sprintf('%s/%s_%03d.csv',params.base_path,sample_id{fileIdx},params.excitation(excitationIdx));
            leg_strings{end+1} = sample_id{fileIdx};
            
            % get data from file
            tab = readtable(this_file);
            wl = tab.Var1;
            cps = tab.Var2;
            
            % adjust as necessary
            if(strcmp(sample_id{fileIdx},'ctrl_002'))
                thisControl = cps;
            elseif( colIdx ~= 1)
%                 cps = cps-thisControl;
            end
            
            leg_plots(end+1) = plot(wl,cps,'LineWidth',1.5);
            %             ylim([0,6e4]);
            xlim([240,800]);
        end
        
        xl = xline(thisExcitation,':',sprintf('%d nm',thisExcitation));
        xl.LabelVerticalAlignment = 'bottom';
        xl.LabelHorizontalAlignment = 'left';
        xl.FontSize = 8;
        xl.FontWeight = 'bold';
        xl.LineWidth = 2;
        if(excitationIdx == 1)
            legend(leg_plots,leg_strings,'Interpreter','none','Location','north outside','Orientation','Horizontal');
        end
        if(excitationIdx ~= length(params.excitation))
            ax.XTickLabel = {};
            ax.XAxis.Visible = 'off';
        else
            xlabel('\bfWavelength [nm]');
        end
        if(colIdx == 1)
%             ylabel('\bfIntensity');
        else
            ax.YTickLabel = {'  '};
            ax.YAxis.Visible = 'off';
        end
        ax.YAxis.Exponent = 0;
        ax.YAxis.TickLabelFormat = '%0.0e';
        linkaxes(axrow(excitationIdx).ah,'xy');

    end
end


