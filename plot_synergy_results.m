function plot_synergy_results(H_matrices, subject_id, condition_id, activity_names)
    num_activities = length(H_matrices);
    
    if num_activities == 0
        disp('No activity data to plot.');
        return;
    end
    
    muscle_labels = {'BB', 'PD', 'AD', 'MD', 'TL', 'WF', 'WE', 'BR'};
    
    figure;
    tiledlayout(2,4, 'TileSpacing', 'compact', 'Padding', 'compact'); % 2x4 grid

    for act = 1:num_activities
        nexttile;
        b = bar(H_matrices{act}, 'grouped');
        
        xlabel('Synergies');
        ylabel('Activation Weight');
        title(sprintf('%s - %s', subject_id, activity_names{act}), 'FontSize', 12);
        
        xticklabels({'S1', 'S2', 'S3', 'S4', 'S5'});
        xtickangle(45);
        grid on;
        
        % Add muscle labels above bars
        [num_synergies, num_muscles] = size(H_matrices{act});
        for i = 1:num_synergies
            for j = 1:num_muscles
                x = b(j).XEndPoints(i);
                y = b(j).YEndPoints(i);
                if H_matrices{act}(i, j) > 0
                    text(x, y + 0.02 * max(H_matrices{act}(:)), muscle_labels{j}, ...
                        'HorizontalAlignment', 'center', ...
                        'VerticalAlignment', 'bottom', ...
                        'FontSize', 8, 'Color', 'k', 'FontWeight', 'bold');
                end
            end
        end
    end
    
    % Add legend for muscle labels
    legend(muscle_labels, 'Location', 'southoutside', 'Orientation', 'horizontal');
end
