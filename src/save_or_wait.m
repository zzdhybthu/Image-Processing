function save_or_wait(gcf, bmp, title)
    % Save the figure if the title is not empty, otherwise wait for the user to close the figure
    % gcf [int]: handle of the current figure
    % bmp [bool]: whether to save the figure as a bmp file
    % title [str] [optional]: title of the figure, excluding the file extension. If empty, wait for the user to close the figure
    % return: None

    if nargin < 3
        waitfor(gcf);
    else
        if bmp
            frame = getframe(gcf);
            imwrite(frame.cdata, strcat(title, '.bmp'));
        else
            saveas(gcf, strcat(title, '.png'));
        end
    end
    close;

end