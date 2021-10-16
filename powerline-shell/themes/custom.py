from powerline_shell.themes.default import DefaultColor


class Color(DefaultColor):
    """Basic theme which only uses colors in 0-15 range"""
    USERNAME_FG = 234
    USERNAME_BG = 231
    USERNAME_ROOT_BG = 1

    HOSTNAME_FG = 234
    HOSTNAME_BG = 252

    HOME_SPECIAL_DISPLAY = False
    PATH_BG = 25
    PATH_FG = 249  # light grey
    CWD_FG = 231  # white
    SEPARATOR_FG = 7

    READONLY_BG = 1
    READONLY_FG = 231

    REPO_CLEAN_BG = 64   # green
    REPO_CLEAN_FG = 231
    REPO_DIRTY_BG = 166   # red
    REPO_DIRTY_FG = 231  # white

    GIT_NOTSTAGED_FG = 231
    GIT_NOTSTAGED_BG = 130

    GIT_STAGED_FG = 231
    GIT_STAGED_BG = 70

    GIT_UNTRACKED_FG = 231
    GIT_UNTRACKED_BG = 240

    GIT_AHEAD_FG = 231
    GIT_AHEAD_BG = 66

    GIT_BEHIND_FG = 236
    GIT_BEHIND_BG = 220

    GIT_CONFLICTED_FG = 231
    GIT_CONFLICTED_BG = 124

    JOBS_FG = 153
    JOBS_BG = 240

    CMD_PASSED_BG = 8
    CMD_PASSED_FG = 15
    CMD_FAILED_BG = 11
    CMD_FAILED_FG = 0

    SVN_CHANGES_BG = REPO_DIRTY_BG
    SVN_CHANGES_FG = REPO_DIRTY_FG

    VIRTUAL_ENV_BG = 2
    VIRTUAL_ENV_FG = 0

    AWS_PROFILE_FG = 14
    AWS_PROFILE_BG = 8

    TIME_FG = 8
    TIME_BG = 7
