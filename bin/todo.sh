#!/usr/bin/env bash

# === HEAVY LIFTING ===
shopt -s extglob extquote

# NOTE:  Todo.sh requires a configuration file to run.
# Place it in one of the default locations or use the -d option for a custom location.

[ -f VERSION-FILE ] && . VERSION-FILE || VERSION="2.13.0"
version() {
    cat <<-EndVersion
		TODO.TXT Command Line Interface v$VERSION

		Homepage: http://todotxt.org
		Code repository: https://github.com/todotxt/todo.txt-cli/
		Contributors: https://github.com/todotxt/todo.txt-cli/graphs/contributors
		License: https://github.com/todotxt/todo.txt-cli/blob/master/LICENSE
	EndVersion
    exit 1
}

# Set script name and full path early.
TODO_SH=$(basename "$0")
TODO_FULL_SH="$0"
export TODO_SH TODO_FULL_SH

oneline_usage="$TODO_SH [-fhpantvV] [-d todo_config] action [task_number] [task_description]"

usage()
{
    cat <<-EndUsage
		Usage: $oneline_usage
		Try '$TODO_SH -h' for more information.
	EndUsage
    exit 1
}

shorthelp()
{
    cat <<-EndHelp
		  Usage: $oneline_usage

		  Actions:
		    add|a "THING I NEED TO DO +project @context"
		    addm "THINGS I NEED TO DO
		          MORE THINGS I NEED TO DO"
		    addto DEST "TEXT TO ADD"
		    append|app ITEM# "TEXT TO APPEND"
		    archive
		    command [ACTIONS]
		    deduplicate
		    del|rm ITEM# [TERM]
		    depri|dp ITEM#[, ITEM#, ITEM#, ...]
		    done|do ITEM#[, ITEM#, ITEM#, ...]
		    help [ACTION...]
		    list|ls [TERM...]
		    listall|lsa [TERM...]
		    listaddons
		    listcon|lsc [TERM...]
		    listfile|lf [SRC [TERM...]]
		    listpri|lsp [PRIORITIES] [TERM...]
		    listproj|lsprj [TERM...]
		    move|mv ITEM# DEST [SRC]
		    prepend|prep ITEM# "TEXT TO PREPEND"
		    pri|p ITEM# PRIORITY[, ITEM# PRIORITY, ...]
		    replace ITEM# "UPDATED TODO"
		    report
		    shorthelp

		  Actions can be added and overridden using scripts in the actions
		  directory.
	EndHelp

    # Only list the one-line usage from the add-on actions. This assumes that
    # add-ons use the same usage indentation structure as todo.sh.
    addonHelp | grep -e '^  Add-on Actions:' -e '^    [[:alpha:]]'

    cat <<-EndHelpFooter

		  See "help" for more details.
	EndHelpFooter
}

help()
{
    local indentedJoinedConfigFileLocations
    printf -v indentedJoinedConfigFileLocations '          %s\n' "${configFileLocations[@]}"
    cat <<-EndOptionsHelp
		  Usage: $oneline_usage

		  Options:
		    -@
		        Hide context names in list output.  Use twice to show context
		        names (default).
		    -+
		        Hide project names in list output.  Use twice to show project
		        names (default).
		    -c
		        Color mode
		    -d CONFIG_FILE
		        Use a configuration file other than one of the defaults:
$indentedJoinedConfigFileLocations
		    -f
		        Forces actions without confirmation or interactive input
		    -h
		        Display a short help message; same as action "shorthelp"
		    -p
		        Plain mode turns off colors
		    -P
		        Hide priority labels in list output.  Use twice to show
		        priority labels (default).
		    -a
		        Don't auto-archive tasks automatically on completion
		    -A
		        Auto-archive tasks automatically on completion
		    -n
		        Don't preserve line numbers; automatically remove blank lines
		        on task deletion
		    -N
		        Preserve line numbers
		    -t
		        Prepend the current date to a task automatically
		        when it's added.
		    -T
		        Do not prepend the current date to a task automatically
		        when it's added.
		    -v
		        Verbose mode turns on confirmation messages
		    -vv
		        Extra verbose mode prints some debugging information and
		        additional help text
		    -V
		        Displays version, license and credits
		    -x
		        Disables TODOTXT_FINAL_FILTER

	EndOptionsHelp

    [ "$TODOTXT_VERBOSE" -gt 1 ] && cat <<-'EndVerboseHelp'
		  Environment variables:
		    TODOTXT_AUTO_ARCHIVE            is same as option -a (0)/-A (1)
		    TODOTXT_CFG_FILE=CONFIG_FILE    is same as option -d CONFIG_FILE
		    TODOTXT_FORCE=1                 is same as option -f
		    TODOTXT_PRESERVE_LINE_NUMBERS   is same as option -n (0)/-N (1)
		    TODOTXT_PLAIN                   is same as option -p (1)/-c (0)
		    TODOTXT_DATE_ON_ADD             is same as option -t (1)/-T (0)
		    TODOTXT_PRIORITY_ON_ADD=pri     default priority A-Z
		    TODOTXT_VERBOSE=1               is same as option -v
		    TODOTXT_DISABLE_FILTER=1        is same as option -x
		    TODOTXT_DEFAULT_ACTION=""       run this when called with no arguments
		    TODOTXT_SORT_COMMAND="sort ..." customize list output
		    TODOTXT_FINAL_FILTER="sed ..."  customize list after color, P@+ hiding
		    TODOTXT_SOURCEVAR=\$DONE_FILE   use another source for listcon, listproj
		    TODOTXT_SIGIL_BEFORE_PATTERN="" optionally allow chars preceding +p / @c
		    TODOTXT_SIGIL_VALID_PATTERN=.*  tweak the allowed chars for +p and @c
		    TODOTXT_SIGIL_AFTER_PATTERN=""  optionally allow chars after +p / @c

	EndVerboseHelp
        actionsHelp
        addonHelp
}

actionsHelp()
{
    cat <<-EndActionsHelp
		  Built-in Actions:
		    add "THING I NEED TO DO +project @context"
		    a "THING I NEED TO DO +project @context"
		      Adds THING I NEED TO DO to your todo.txt file on its own line.
		      Project and context notation optional.
		      Quotes optional.

		    addm "FIRST THING I NEED TO DO +project1 @context
		    SECOND THING I NEED TO DO +project2 @context"
		      Adds FIRST THING I NEED TO DO to your todo.txt on its own line and
		      Adds SECOND THING I NEED TO DO to you todo.txt on its own line.
		      Project and context notation optional.

		    addto DEST "TEXT TO ADD"
		      Adds a line of text to any file located in the todo.txt directory.
		      For example, addto inbox.txt "decide about vacation"

		    append ITEM# "TEXT TO APPEND"
		    app ITEM# "TEXT TO APPEND"
		      Adds TEXT TO APPEND to the end of the task on line ITEM#.
		      Quotes optional.

		    archive
		      Moves all done tasks from todo.txt to done.txt and removes blank lines.

		    command [ACTIONS]
		      Runs the remaining arguments using only todo.sh builtins.
		      Will not call any .todo.actions.d scripts.

		    deduplicate
		      Removes duplicate lines from todo.txt.

		    del ITEM# [TERM]
		    rm ITEM# [TERM]
		      Deletes the task on line ITEM# in todo.txt.
		      If TERM specified, deletes only TERM from the task.

		    depri ITEM#[, ITEM#, ITEM#, ...]
		    dp ITEM#[, ITEM#, ITEM#, ...]
		      Deprioritizes (removes the priority) from the task(s)
		      on line ITEM# in todo.txt.

		    done ITEM#[, ITEM#, ITEM#, ...]
		    do ITEM#[, ITEM#, ITEM#, ...]
		      Marks task(s) on line ITEM# as done in todo.txt.

		    help [ACTION...]
		      Display help about usage, options, built-in and add-on actions,
		      or just the usage help for the passed ACTION(s).

		    list [TERM...]
		    ls [TERM...]
		      Displays all tasks that contain TERM(s) sorted by priority with line
		      numbers.  Each task must match all TERM(s) (logical AND); to display
		      tasks that contain any TERM (logical OR), use
		      'TERM1\|TERM2\|...' (with quotes), or TERM1\\\|TERM2 (unquoted).
		      Hides all tasks that contain TERM(s) preceded by a
		      minus sign (i.e. -TERM).
		      TERM(s) are grep-style basic regular expressions; for literal matching,
		      put a single backslash before any [ ] \ $ * . ^ and enclose the entire
		      TERM in single quotes, or use double backslashes and extra shell-quoting.
		      If no TERM specified, lists entire todo.txt.

		    listall [TERM...]
		    lsa [TERM...]
		      Displays all the lines in todo.txt AND done.txt that contain TERM(s)
		      sorted by priority with line  numbers.  Hides all tasks that
		      contain TERM(s) preceded by a minus sign (i.e. -TERM).  If no
		      TERM specified, lists entire todo.txt AND done.txt
		      concatenated and sorted.

		    listaddons
		      Lists all added and overridden actions in the actions directory.

		    listcon [TERM...]
		    lsc [TERM...]
		      Lists all the task contexts that start with the @ sign in todo.txt.
		      If TERM specified, considers only tasks that contain TERM(s).

		    listfile [SRC [TERM...]]
		    lf [SRC [TERM...]]
		      Displays all the lines in SRC file located in the todo.txt directory,
		      sorted by priority with line  numbers.  If TERM specified, lists
		      all lines that contain TERM(s) in SRC file.  Hides all tasks that
		      contain TERM(s) preceded by a minus sign (i.e. -TERM).
		      Without any arguments, the names of all text files in the todo.txt
		      directory are listed.

		    listpri [PRIORITIES] [TERM...]
		    lsp [PRIORITIES] [TERM...]
		      Displays all tasks prioritized PRIORITIES.
		      PRIORITIES can be a [concatenation of] single (A) or range (A-C).
		      If no PRIORITIES specified, lists all prioritized tasks.
		      If TERM specified, lists only prioritized tasks that contain TERM(s).
		      Hides all tasks that contain TERM(s) preceded by a minus sign
		      (i.e. -TERM).

		    listproj [TERM...]
		    lsprj [TERM...]
		      Lists all the projects (terms that start with a + sign) in
		      todo.txt.
		      If TERM specified, considers only tasks that contain TERM(s).

		    move ITEM# DEST [SRC]
		    mv ITEM# DEST [SRC]
		      Moves a line from source text file (SRC) to destination text file (DEST).
		      Both source and destination file must be located in the directory defined
		      in the configuration directory.  When SRC is not defined
		      it's by default todo.txt.

		    prepend ITEM# "TEXT TO PREPEND"
		    prep ITEM# "TEXT TO PREPEND"
		      Adds TEXT TO PREPEND to the beginning of the task on line ITEM#.
		      Quotes optional.

		    pri ITEM# PRIORITY
		    p ITEM# PRIORITY
		      Adds PRIORITY to task on line ITEM#.  If the task is already
		      prioritized, replaces current priority with new PRIORITY.
		      PRIORITY must be a letter between A and Z.

		    replace ITEM# "UPDATED TODO"
		      Replaces task on line ITEM# with UPDATED TODO.

		    report
		      Adds the number of open tasks and done tasks to report.txt.

		    shorthelp
		      List the one-line usage of all built-in and add-on actions.

	EndActionsHelp
}

addonHelp()
{
    if [ -d "$TODO_ACTIONS_DIR" ]; then
        didPrintAddonActionsHeader=
        for action in "$TODO_ACTIONS_DIR"/*
        do
            if [ -f "$action" ] && [ -x "$action" ]; then
                if [ ! "$didPrintAddonActionsHeader" ]; then
                    cat <<-EndAddonActionsHeader
		  Add-on Actions:
	EndAddonActionsHeader
                    didPrintAddonActionsHeader=1
                fi
                "$action" usage
            elif [ -d "$action" ] && [ -x "$action"/"$(basename "$action")" ]; then
                if [ ! "$didPrintAddonActionsHeader" ]; then
                    cat <<-EndAddonActionsHeader
		  Add-on Actions:
	EndAddonActionsHeader
                    didPrintAddonActionsHeader=1
                fi
                "$action"/"$(basename "$action")" usage
            fi
        done
    fi
}

actionUsage()
{
    for actionName
    do
        action="${TODO_ACTIONS_DIR}/${actionName}"
        if [ -f "$action" ] && [ -x "$action" ]; then
            "$action" usage
        elif [ -d "$action" ] && [ -x "$action"/"$(basename "$action")" ]; then
            "$action"/"$(basename "$action")" usage
        else
            builtinActionUsage=$(actionsHelp | sed -n -e "/^    ${actionName//\//\\/} /,/^\$/p" -e "/^    ${actionName//\//\\/}$/,/^\$/p")
            if [ "$builtinActionUsage" ]; then
                echo "$builtinActionUsage"
                echo
            else
                die "TODO: No action \"${actionName}\" exists."
            fi
        fi
    done
}

dieWithHelp()
{
    case "$1" in
        help)       help;;
        shorthelp)  shorthelp;;
    esac >&2
    shift

    die "$@"
}
die()
{
    echo >&2 "$*"
    exit 1
}

confirm()
{
    [ $TODOTXT_FORCE = 0 ] || return 0

    local readArgs=(-e -r)
    [ -n "${BASH_VERSINFO:-}" ] && [ \( ${BASH_VERSINFO[0]} -eq 4 -a ${BASH_VERSINFO[1]} -ge 1 \) -o ${BASH_VERSINFO[0]} -gt 4 ] &&
        readArgs+=(-N 1)    # Bash 4.1+ supports -N nchars
    local answer
    read -p "${1:?}? (y/n) " "${readArgs[@]}" answer
    echo
    [ "$answer" = "y" ]
}

cleaninput()
{
    # Parameters:    When $1 = "for sed", performs additional escaping for use
    #                in sed substitution with "|" separators.
    # Precondition:  $input contains text to be cleaned.
    # Postcondition: Modifies $input.

    # Replace CR and LF with space; tasks always comprise a single line.
    input=${input//$'\r'/ }
    input=${input//$'\n'/ }

    if [ "$1" = "for sed" ]; then
        # This action uses sed with "|" as the substitution separator, and & as
        # the matched string; these must be escaped.
        # Backslashes must be escaped, too, and before the other stuff.
        input=${input//\\/\\\\}
        input=${input//|/\\|}
        input=${input//&/\\&}
    fi
}

getPrefix()
{
    # Parameters:    $1: todo file; empty means $TODO_FILE.
    # Returns:       Uppercase FILE prefix to be used in place of "TODO:" where
    #                a different todo file can be specified.
    local base
    base=$(basename "${1:-$TODO_FILE}")
    echo "${base%%.[^.]*}" | tr '[:lower:]' '[:upper:]'
}

getTodo()
{
    # Parameters:    $1: task number
    #                $2: Optional todo file
    # Precondition:  $errmsg contains usage message.
    # Postcondition: $todo contains task text.

    local item=$1
    [ -z "$item" ] && die "$errmsg"
    [ "${item//[0-9]/}" ] && die "$errmsg"

    todo=$(sed "$item!d" "${2:-$TODO_FILE}")
    [ -z "$todo" ] && die "$(getPrefix "$2"): No task $item."
}
getNewtodo()
{
    # Parameters:    $1: task number
    #                $2: Optional todo file
    # Precondition:  None.
    # Postcondition: $newtodo contains task text.

    local item=$1
    [ -z "$item" ] && die "Programming error: $item should exist."
    [ "${item//[0-9]/}" ] && die "Programming error: $item should be numeric."

    newtodo=$(sed "$item!d" "${2:-$TODO_FILE}")
    [ -z "$newtodo" ] && die "$(getPrefix "$2"): No updated task $item."
}

replaceOrPrepend()
{
  action=$1; shift
  case "$action" in
    replace)
      backref=
      querytext="Replacement: "
      ;;
    prepend)
      backref=' &'
      querytext="Prepend: "
      ;;
  esac
  shift; item=$1; shift
  getTodo "$item"

  if [[ -z "$1" && $TODOTXT_FORCE = 0 ]]; then
    read -p "$querytext" -r -i "$todo" -e input
  else
    input=$*
  fi

  # Retrieve existing priority and prepended date
  local -r priAndDateExpr='^\((.) \)\{0,1\}\([0-9]\{2,4\}-[0-9]\{2\}-[0-9]\{2\} \)\{0,1\}'
  originalPriority=$(sed -e "$item!d" -e "${item}s/${priAndDateExpr}.*/\\1/" "$TODO_FILE")
  priority="$originalPriority"
  originalPrepdate=$(sed -e "$item!d" -e "${item}s/${priAndDateExpr}.*/\\2/" "$TODO_FILE")
  prepdate="$originalPrepdate"
  if [ "$action" = "replace" ]; then
    replacementPrepdate="$(echo "$input"|sed -e "s/${priAndDateExpr}.*/\\2/")"
    if [ "$replacementPrepdate" ]; then
      # If the replaced text starts with a [priority +] date, it will replace
      # the existing date, too.
      prepdate="$replacementPrepdate"
    fi
    replacementPriority="$(echo "$input"|sed -e "s/${priAndDateExpr}.*/\\1/")"
    if [ "$replacementPriority" ]; then
      # If the replaced text starts with a priority, it will replace
      # the existing priority, too.
      priority="$replacementPriority"
    fi
    input="$(echo "$input"|sed -e "s/${priAndDateExpr}//")"
  fi

  # Temporarily remove any existing priority and prepended date, perform the
  # change (replace/prepend) and re-insert the existing priority and prepended
  # date again.
  cleaninput "for sed"
  sed -i.bak -e "$item s/^${originalPriority}${originalPrepdate}//" -e "$item s|^.*|${priority}${prepdate}${input}${backref}|" "$TODO_FILE"
  if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
    getNewtodo "$item"
    case "$action" in
      replace)
        echo "$item $todo"
        echo "TODO: Replaced task with:"
        echo "$item $newtodo"
        ;;
      prepend)
        echo "$item $newtodo"
        ;;
    esac
  fi
}

fixMissingEndOfLine()
{
    # Parameters:    $1: todo file; empty means $TODO_FILE.
    todo_path="${1:-$TODO_FILE}"
    [[ -f $todo_path && $(tail -c1 "$todo_path") ]] && echo "" >> "$todo_path"    
}

uppercasePriority()
{
    # Precondition:  $input contains task text for which to uppercase priority.
    # Postcondition: Modifies $input.
    lower=( {a..z} )
    upper=( {A..Z} )
    for ((i=0; i<26; i++))
    do
        upperPriority="${upperPriority};s/^[(]${lower[i]}[)]/(${upper[i]})/"
    done
    input=$(echo "$input" | sed "$upperPriority")
}

#Preserving environment variables so they don't get clobbered by the config file
OVR_TODOTXT_AUTO_ARCHIVE="$TODOTXT_AUTO_ARCHIVE"
OVR_TODOTXT_FORCE="$TODOTXT_FORCE"
OVR_TODOTXT_PRESERVE_LINE_NUMBERS="$TODOTXT_PRESERVE_LINE_NUMBERS"
OVR_TODOTXT_PLAIN="$TODOTXT_PLAIN"
OVR_TODOTXT_DATE_ON_ADD="$TODOTXT_DATE_ON_ADD"
OVR_TODOTXT_PRIORITY_ON_ADD="$TODOTXT_PRIORITY_ON_ADD"
OVR_TODOTXT_DISABLE_FILTER="$TODOTXT_DISABLE_FILTER"
OVR_TODOTXT_VERBOSE="$TODOTXT_VERBOSE"
OVR_TODOTXT_DEFAULT_ACTION="$TODOTXT_DEFAULT_ACTION"
OVR_TODOTXT_SORT_COMMAND="$TODOTXT_SORT_COMMAND"
OVR_TODOTXT_FINAL_FILTER="$TODOTXT_FINAL_FILTER"

# Prevent GREP_OPTIONS from malforming grep's output
export GREP_OPTIONS=""

# == PROCESS OPTIONS ==
while getopts ":fhpcnNaAtTvVx+@Pd:" Option
do
  case $Option in
    '@')
        ## HIDE_CONTEXT_NAMES starts at zero (false); increment it to one
        ##   (true) the first time this flag is seen. Each time the flag
        ##   is seen after that, increment it again so that an even
        ##   number shows context names and an odd number hides context
        ##   names.
        : $(( HIDE_CONTEXT_NAMES++ ))
        if [ $(( HIDE_CONTEXT_NAMES % 2 )) -eq 0 ]
        then
            ## Zero or even value -- show context names
            unset HIDE_CONTEXTS_SUBSTITUTION
        else
            ## One or odd value -- hide context names
            export HIDE_CONTEXTS_SUBSTITUTION='[[:space:]]@[[:graph:]]\{1,\}'
        fi
        ;;
    '+')
        ## HIDE_PROJECT_NAMES starts at zero (false); increment it to one
        ##   (true) the first time this flag is seen. Each time the flag
        ##   is seen after that, increment it again so that an even
        ##   number shows project names and an odd number hides project
        ##   names.
        : $(( HIDE_PROJECT_NAMES++ ))
        if [ $(( HIDE_PROJECT_NAMES % 2 )) -eq 0 ]
        then
            ## Zero or even value -- show project names
            unset HIDE_PROJECTS_SUBSTITUTION
        else
            ## One or odd value -- hide project names
            export HIDE_PROJECTS_SUBSTITUTION='[[:space:]][+][[:graph:]]\{1,\}'
        fi
        ;;
    a)
        OVR_TODOTXT_AUTO_ARCHIVE=0
        ;;
    A)
        OVR_TODOTXT_AUTO_ARCHIVE=1
        ;;
    c)
        OVR_TODOTXT_PLAIN=0
        ;;
    d)
        TODOTXT_CFG_FILE=$OPTARG
        ;;
    f)
        OVR_TODOTXT_FORCE=1
        ;;
    h)
        # Short-circuit option parsing and forward to the action.
        # Cannot just invoke shorthelp() because we need the configuration
        # processed to locate the add-on actions directory.
        set -- '-h' 'shorthelp'
        OPTIND=2
        ;;
    n)
        OVR_TODOTXT_PRESERVE_LINE_NUMBERS=0
        ;;
    N)
        OVR_TODOTXT_PRESERVE_LINE_NUMBERS=1
        ;;
    p)
        OVR_TODOTXT_PLAIN=1
        ;;
    P)
        ## HIDE_PRIORITY_LABELS starts at zero (false); increment it to one
        ##   (true) the first time this flag is seen. Each time the flag
        ##   is seen after that, increment it again so that an even
        ##   number shows priority labels and an odd number hides priority
        ##   labels.
        : $(( HIDE_PRIORITY_LABELS++ ))
        if [ $(( HIDE_PRIORITY_LABELS % 2 )) -eq 0 ]
        then
            ## Zero or even value -- show priority labels
            unset HIDE_PRIORITY_SUBSTITUTION
        else
            ## One or odd value -- hide priority labels
            export HIDE_PRIORITY_SUBSTITUTION="([A-Z])[[:space:]]"
        fi
        ;;
    t)
        OVR_TODOTXT_DATE_ON_ADD=1
        ;;
    T)
        OVR_TODOTXT_DATE_ON_ADD=0
        ;;
    v)
        : $(( TODOTXT_VERBOSE++ ))
        ;;
    V)
        version
        ;;
    x)
        OVR_TODOTXT_DISABLE_FILTER=1
        ;;
    *)
        usage
        ;;
  esac
done
shift $((OPTIND - 1))

# defaults if not yet defined
TODOTXT_VERBOSE=${TODOTXT_VERBOSE:-1}
TODOTXT_PLAIN=${TODOTXT_PLAIN:-0}
TODOTXT_FORCE=${TODOTXT_FORCE:-0}
TODOTXT_PRESERVE_LINE_NUMBERS=${TODOTXT_PRESERVE_LINE_NUMBERS:-1}
TODOTXT_AUTO_ARCHIVE=${TODOTXT_AUTO_ARCHIVE:-1}
TODOTXT_DATE_ON_ADD=${TODOTXT_DATE_ON_ADD:-0}
TODOTXT_PRIORITY_ON_ADD=${TODOTXT_PRIORITY_ON_ADD:-}
TODOTXT_DEFAULT_ACTION=${TODOTXT_DEFAULT_ACTION:-}
TODOTXT_SORT_COMMAND=${TODOTXT_SORT_COMMAND:-env LC_COLLATE=C sort -f -k2}
TODOTXT_DISABLE_FILTER=${TODOTXT_DISABLE_FILTER:-}
TODOTXT_FINAL_FILTER=${TODOTXT_FINAL_FILTER:-cat}
TODOTXT_GLOBAL_CFG_FILE=${TODOTXT_GLOBAL_CFG_FILE:-/etc/todo/config}
TODOTXT_SIGIL_BEFORE_PATTERN=${TODOTXT_SIGIL_BEFORE_PATTERN:-}	# Allow any other non-whitespace entity before +project and @context; should be an optional match; example: \(w:\)\{0,1\} to allow w:@context.
TODOTXT_SIGIL_VALID_PATTERN=${TODOTXT_SIGIL_VALID_PATTERN:-.*}	# Limit the valid characters (from the default any non-whitespace sequence) for +project and @context; example: [a-zA-Z]\{3,\} to only allow alphabetic ones that are at least three characters long.
TODOTXT_SIGIL_AFTER_PATTERN=${TODOTXT_SIGIL_AFTER_PATTERN:-}	# Allow any other non-whitespace entity after +project and @context; should be an optional match; example: )\{0,1\} to allow (with the corresponding TODOTXT_SIGIL_BEFORE_PATTERN) enclosing in parentheses.

# Export all TODOTXT_* variables
export "${!TODOTXT_@}"

# Default color map
export NONE=''
export BLACK='\\033[0;30m'
export RED='\\033[0;31m'
export GREEN='\\033[0;32m'
export BROWN='\\033[0;33m'
export BLUE='\\033[0;34m'
export PURPLE='\\033[0;35m'
export CYAN='\\033[0;36m'
export LIGHT_GREY='\\033[0;37m'
export DARK_GREY='\\033[1;30m'
export LIGHT_RED='\\033[1;31m'
export LIGHT_GREEN='\\033[1;32m'
export YELLOW='\\033[1;33m'
export LIGHT_BLUE='\\033[1;34m'
export LIGHT_PURPLE='\\033[1;35m'
export LIGHT_CYAN='\\033[1;36m'
export WHITE='\\033[1;37m'
export DEFAULT='\\033[0m'

# Default priority->color map.
export PRI_A=$YELLOW        # color for A priority
export PRI_B=$GREEN         # color for B priority
export PRI_C=$LIGHT_BLUE    # color for C priority
export PRI_X=$WHITE         # color unless explicitly defined

# Default project, context, date, item number, and metadata key:value pairs colors.
export COLOR_PROJECT=$NONE
export COLOR_CONTEXT=$NONE
export COLOR_DATE=$NONE
export COLOR_NUMBER=$NONE
export COLOR_META=$NONE

# Default highlight colors.
export COLOR_DONE=$LIGHT_GREY   # color for done (but not yet archived) tasks

# Default sentence delimiters for todo.sh append.
# If the text to be appended to the task begins with one of these characters, no
# whitespace is inserted in between. This makes appending to an enumeration
# (todo.sh add 42 ", foo") syntactically correct.
export SENTENCE_DELIMITERS=',.:;'

configFileLocations=(
    "$HOME/.todo/config"
    "$HOME/todo.cfg"
    "$HOME/.todo.cfg"
    "${XDG_CONFIG_HOME:-$HOME/.config}/todo/config"
    "$(dirname "$0")/todo.cfg"
    "$TODOTXT_GLOBAL_CFG_FILE"
)

[ -e "$TODOTXT_CFG_FILE" ] || for CFG_FILE_ALT in "${configFileLocations[@]}"
do
    if [ -e "$CFG_FILE_ALT" ]
    then
        TODOTXT_CFG_FILE="$CFG_FILE_ALT"
        break
    fi
done

if [ -z "$TODO_ACTIONS_DIR" ] || [ ! -d "$TODO_ACTIONS_DIR" ]
then
    TODO_ACTIONS_DIR="$HOME/.todo/actions"
    export TODO_ACTIONS_DIR
fi

[ -d "$TODO_ACTIONS_DIR" ] || for TODO_ACTIONS_DIR_ALT in \
    "$HOME/.todo.actions.d" \
    "${XDG_CONFIG_HOME:-$HOME/.config}/todo/actions"
do
    if [ -d "$TODO_ACTIONS_DIR_ALT" ]
    then
        TODO_ACTIONS_DIR="$TODO_ACTIONS_DIR_ALT"
        break
    fi
done


# === SANITY CHECKS (thanks Karl!) ===
[ -r "$TODOTXT_CFG_FILE" ] || dieWithHelp "$1" "Fatal Error: Cannot read configuration file ${TODOTXT_CFG_FILE:-${configFileLocations[0]}}"

. "$TODOTXT_CFG_FILE"

# === APPLY OVERRIDES
if [ -n "$OVR_TODOTXT_AUTO_ARCHIVE" ] ; then
  TODOTXT_AUTO_ARCHIVE="$OVR_TODOTXT_AUTO_ARCHIVE"
fi
if [ -n "$OVR_TODOTXT_FORCE" ] ; then
  TODOTXT_FORCE="$OVR_TODOTXT_FORCE"
fi
if [ -n "$OVR_TODOTXT_PRESERVE_LINE_NUMBERS" ] ; then
  TODOTXT_PRESERVE_LINE_NUMBERS="$OVR_TODOTXT_PRESERVE_LINE_NUMBERS"
fi
if [ -n "$OVR_TODOTXT_PLAIN" ] ; then
  TODOTXT_PLAIN="$OVR_TODOTXT_PLAIN"
fi
if [ -n "$OVR_TODOTXT_DATE_ON_ADD" ] ; then
  TODOTXT_DATE_ON_ADD="$OVR_TODOTXT_DATE_ON_ADD"
fi
if [ -n "$OVR_TODOTXT_PRIORITY_ON_ADD" ] ; then
    TODOTXT_PRIORITY_ON_ADD="$OVR_TODOTXT_PRIORITY_ON_ADD"
fi
if [ -n "$OVR_TODOTXT_DISABLE_FILTER" ] ; then
  TODOTXT_DISABLE_FILTER="$OVR_TODOTXT_DISABLE_FILTER"
fi
if [ -n "$OVR_TODOTXT_VERBOSE" ] ; then
  TODOTXT_VERBOSE="$OVR_TODOTXT_VERBOSE"
fi
if [ -n "$OVR_TODOTXT_DEFAULT_ACTION" ] ; then
  TODOTXT_DEFAULT_ACTION="$OVR_TODOTXT_DEFAULT_ACTION"
fi
if [ -n "$OVR_TODOTXT_SORT_COMMAND" ] ; then
  TODOTXT_SORT_COMMAND="$OVR_TODOTXT_SORT_COMMAND"
fi
if [ -n "$OVR_TODOTXT_FINAL_FILTER" ] ; then
  TODOTXT_FINAL_FILTER="$OVR_TODOTXT_FINAL_FILTER"
fi

ACTION=${1:-$TODOTXT_DEFAULT_ACTION}

[ -z "$ACTION" ]    && usage
[ -d "$TODO_DIR" ]  || mkdir -p "$TODO_DIR" 2> /dev/null || dieWithHelp "$1" "Fatal Error: $TODO_DIR is not a directory"
( cd "$TODO_DIR" )  || dieWithHelp "$1" "Fatal Error: Unable to cd to $TODO_DIR"
[ -z "$TODOTXT_PRIORITY_ON_ADD" ] \
    || echo "$TODOTXT_PRIORITY_ON_ADD" | grep -q "^[A-Z]$" \
    || die "TODOTXT_PRIORITY_ON_ADD should be a capital letter from A to Z (it is now \"$TODOTXT_PRIORITY_ON_ADD\")."

[ -z "$TODO_FILE" ] && TODO_FILE="$TODO_DIR/todo.txt"
[ -z "$DONE_FILE" ] && DONE_FILE="$TODO_DIR/done.txt"
[ -z "$REPORT_FILE" ] && REPORT_FILE="$TODO_DIR/report.txt"

[ -f "$TODO_FILE" ] || [ -c "$TODO_FILE" ] || > "$TODO_FILE"
[ -f "$DONE_FILE" ] || [ -c "$DONE_FILE" ] || > "$DONE_FILE"
[ -f "$REPORT_FILE" ] || [ -c "$REPORT_FILE" ] || > "$REPORT_FILE"

if [ $TODOTXT_PLAIN = 1 ]; then
    for clr in ${!PRI_@}; do
        export "$clr"="$NONE"
    done
    PRI_X=$NONE
    DEFAULT=$NONE
    COLOR_DONE=$NONE
    COLOR_PROJECT=$NONE
    COLOR_CONTEXT=$NONE
    COLOR_DATE=$NONE
    COLOR_NUMBER=$NONE
    COLOR_META=$NONE
fi

[[ "$HIDE_PROJECTS_SUBSTITUTION" ]] && COLOR_PROJECT="$NONE"
[[ "$HIDE_CONTEXTS_SUBSTITUTION" ]] && COLOR_CONTEXT="$NONE"

_addto() {
    file="$1"
    input="$2"
    cleaninput
    uppercasePriority

    if [[ "$TODOTXT_DATE_ON_ADD" -eq 1 ]]; then
        now=$(date '+%Y-%m-%d')
        input=$(echo "$input" | sed -e 's/^\(([A-Z]) \)\{0,1\}/\1'"$now /")
    fi
    if [[ -n "$TODOTXT_PRIORITY_ON_ADD" ]]; then
        if ! echo "$input" | grep -q '^([A-Z])'; then
            input=$(echo -n "($TODOTXT_PRIORITY_ON_ADD) " ; echo "$input")
        fi
    fi
    fixMissingEndOfLine "$file"
    echo "$input" >> "$file"
    if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
        TASKNUM=$(sed -n '$ =' "$file")
        echo "$TASKNUM $input"
        echo "$(getPrefix "$file"): $TASKNUM added."
    fi
}

filtercommand()
{
    filter=${1:-}
    shift
    post_filter=${1:-}
    shift

    for search_term
    do
        ## See if the first character of $search_term is a dash
        if [ "${search_term:0:1}" != '-' ]
        then
            ## First character isn't a dash: hide lines that don't match
            ## this $search_term
            printf -v filter '%sgrep -i %q' "${filter:-}${filter:+ | }" "$search_term"
        else
            ## First character is a dash: hide lines that match this
            ## $search_term
            #
            ## Remove the first character (-) before adding to our filter command
            printf -v filter '%sgrep -v -i %q' "${filter:-}${filter:+ | }" "${search_term:1}"
        fi
    done

    [ -n "$post_filter" ] && {
        filter="${filter:-}${filter:+ | }${post_filter:-}"
    }

    printf %s "$filter"
}

_list() {
    local FILE="$1"
    ## If the file starts with a "/" use absolute path. Otherwise,
    ## try to find it in either $TODO_DIR or using a relative path
    if [ "${1:0:1}" == / ]; then
        ## Absolute path
        src="$FILE"
    elif [ -f "$TODO_DIR/$FILE" ]; then
        ## Path relative to todo.sh directory
        src="$TODO_DIR/$FILE"
    elif [ -f "$FILE" ]; then
        ## Path relative to current working directory
        src="$FILE"
    elif [ -f "$TODO_DIR/${FILE}.txt" ]; then
        ## Path relative to todo.sh directory, missing file extension
        src="$TODO_DIR/${FILE}.txt"
    else
        die "TODO: File $FILE does not exist."
    fi

    ## Get our search arguments, if any
    shift ## was file name, new $1 is first search term

    _format "$src" '' "$@"

    if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
        echo "--"
        echo "$(getPrefix "$src"): ${NUMTASKS:-0} of ${TOTALTASKS:-0} tasks shown"
    fi
}
getPadding()
{
    ## We need one level of padding for each power of 10 $LINES uses.
    LINES=$(sed -n '$ =' "${1:-$TODO_FILE}")
    printf %s ${#LINES}
}
_format()
{
    # Parameters:    $1: todo input file; when empty formats stdin
    #                $2: ITEM# number width; if empty auto-detects from $1 / $TODO_FILE.
    # Precondition:  None
    # Postcondition: $NUMTASKS and $TOTALTASKS contain statistics (unless $TODOTXT_VERBOSE=0).

    FILE=$1
    shift

    ## Figure out how much padding we need to use, unless this was passed to us.
    PADDING=${1:-$(getPadding "$FILE")}
    shift

    ## Number the file, then run the filter command,
    ## then sort and mangle output some more
    if [[ $TODOTXT_DISABLE_FILTER = 1 ]]; then
        TODOTXT_FINAL_FILTER="cat"
    fi
    items=$(
        if [ "$FILE" ]; then
            sed = "$FILE"
        else
            sed =
        fi                                                      \
        | sed -e '''
            N
            s/^/     /
            s/ *\([ 0-9]\{'"$PADDING"',\}\)\n/\1 /
            /^[ 0-9]\{1,\} *$/d
         '''
    )

    ## Build and apply the filter.
    filter_command=$(filtercommand "${pre_filter_command:-}" "${post_filter_command:-}" "$@")
    if [ "${filter_command}" ]; then
        filtered_items=$(echo -n "$items" | eval "${filter_command}")
    else
        filtered_items=$items
    fi
    filtered_items=$(
        echo -n "$filtered_items"                              \
        | sed '''
            s/^     /00000/;
            s/^    /0000/;
            s/^   /000/;
            s/^  /00/;
            s/^ /0/;
          ''' \
        | eval "${TODOTXT_SORT_COMMAND}" \
        | awk '''
            function highlight(colorVar,      color) {
                color = ENVIRON[colorVar]
                gsub(/\\+033/, "\033", color)
                return color
            }
            {
                clr = ""
                if (match($0, /^[0-9]+ x /)) {
                    clr = highlight("COLOR_DONE")
                } else if (match($0, /^[0-9]+ \([A-Z]\) /)) {
                    clr = highlight("PRI_" substr($0, RSTART + RLENGTH - 3, 1))
                    clr = (clr ? clr : highlight("PRI_X"))
                    if (ENVIRON["HIDE_PRIORITY_SUBSTITUTION"] != "") {
                        $0 = substr($0, 1, RLENGTH - 4) substr($0, RSTART + RLENGTH)
                    }
                }
                end_clr = (clr ? highlight("DEFAULT") : "")

                prj_beg = highlight("COLOR_PROJECT")
                prj_end = (prj_beg ? (highlight("DEFAULT") clr) : "")

                ctx_beg = highlight("COLOR_CONTEXT")
                ctx_end = (ctx_beg ? (highlight("DEFAULT") clr) : "")

                dat_beg = highlight("COLOR_DATE")
                dat_end = (dat_beg ? (highlight("DEFAULT") clr) : "")

                num_beg = highlight("COLOR_NUMBER")
                num_end = (num_beg ? (highlight("DEFAULT") clr) : "")

                met_beg = highlight("COLOR_META")
                met_end = (met_beg ? (highlight("DEFAULT") clr) : "")

                gsub(/[ \t][ \t]*/, "\n&\n")
                len = split($0, words, /\n/)

                printf "%s", clr
                for (i = 1; i <= len; ++i) {
                    if (i == 1 && words[i] ~ /^[0-9]+$/ ) {
                        printf "%s", num_beg words[i] num_end
                    } else if (words[i] ~ /^[+].*[A-Za-z0-9_]$/) {
                        printf "%s", prj_beg words[i] prj_end
                    } else if (words[i] ~ /^[@].*[A-Za-z0-9_]$/) {
                        printf "%s", ctx_beg words[i] ctx_end
                    } else if (words[i] ~ /^(19|20)[0-9][0-9]-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/) {
                        printf "%s", dat_beg words[i] dat_end
                    } else if (words[i] ~ /^[A-Za-z0-9]+:[^ ]+$/) {
                        printf "%s", met_beg words[i] met_end
                    } else {
                        printf "%s", words[i]
                    }
                }
                printf "%s\n", end_clr
            }
          '''  \
        | sed '''
            s/'"${HIDE_PROJECTS_SUBSTITUTION:-^}"'//g
            s/'"${HIDE_CONTEXTS_SUBSTITUTION:-^}"'//g
            s/'"${HIDE_CUSTOM_SUBSTITUTION:-^}"'//g
          '''                                                   \
        | eval ${TODOTXT_FINAL_FILTER}                          \
    )
    [ "$filtered_items" ] && echo "$filtered_items"

    if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
        NUMTASKS=$( echo -n "$filtered_items" | sed -n '$ =' )
        TOTALTASKS=$( echo -n "$items" | sed -n '$ =' )
    fi
    if [ "$TODOTXT_VERBOSE" -gt 1 ]; then
        echo "TODO DEBUG: Filter Command was: ${filter_command:-cat}"
    fi
}

listWordsWithSigil()
{
    sigil=$1
    shift

    FILE=$TODO_FILE
    [ "$TODOTXT_SOURCEVAR" ] && eval "FILE=$TODOTXT_SOURCEVAR"
	eval "$(filtercommand 'cat "${FILE[@]}"' '' "$@")" \
		| grep -o "[^ ]*${sigil}[^ ]\\+" \
		| sed -n \
			-e "s#^${TODOTXT_SIGIL_BEFORE_PATTERN//#/\\#}##" \
			-e "s#${TODOTXT_SIGIL_AFTER_PATTERN//#/\\#}\$##" \
			-e "/^${sigil}${TODOTXT_SIGIL_VALID_PATTERN//\//\\/}$/p" \
		| sort -u
}

hasCustomAction()
{
    [ -d "${1:?}" ] || return 1
    [ -x "$1/${2:?}" ] && return 0
    if [ -h "$1/$2" ] && [ ! -e "$1/$2" ]
    then
        dieWithHelp "$2" "Fatal Error: Broken link to custom action: '$1/$2'"
    fi
    return 1
}

export -f cleaninput getPrefix getTodo getNewtodo filtercommand _list listWordsWithSigil getPadding _format die

# == HANDLE ACTION ==
action=$( printf "%s\n" "$ACTION" | tr '[:upper:]' '[:lower:]' )

## If the first argument is "command", run the rest of the arguments
## using todo.sh builtins.
## Else, run a actions script with the name of the command if it exists
## or fallback to using a builtin
if [ "$action" == command ]
then
    ## Get rid of "command" from arguments list
    shift
    ## Reset action to new first argument
    action=$( printf "%s\n" "$1" | tr '[:upper:]' '[:lower:]' )
elif hasCustomAction "$TODO_ACTIONS_DIR/$action" "$action"
then
    "$TODO_ACTIONS_DIR/$action/$action" "$@"
    exit $?
elif hasCustomAction "$TODO_ACTIONS_DIR" "$action"
then
    "$TODO_ACTIONS_DIR/$action" "$@"
    exit $?
fi

## Only run if $action isn't found in .todo.actions.d
case $action in
"add" | "a")
    if [[ -z "$2" && $TODOTXT_FORCE = 0 ]]; then
        read -p "Add: " -e -r input
    else
        [ -z "$2" ] && die "usage: $TODO_SH add \"TODO ITEM\""
        shift
        input=$*
    fi
    _addto "$TODO_FILE" "$input"
    ;;

"addm")
    if [[ -z "$2" && $TODOTXT_FORCE = 0 ]]; then
        read -p "Add: " -e -r input
    else
        [ -z "$2" ] && die "usage: $TODO_SH addm \"TODO ITEM\""
        shift
        input=$*
    fi

    # Set Internal Field Seperator as newline so we can
    # loop across multiple lines
    SAVEIFS=$IFS
    IFS=$'\n'

    # Treat each line separately
    for line in $input ; do
        _addto "$TODO_FILE" "$line"
    done
    IFS=$SAVEIFS
    ;;

"addto" )
    [ -z "$2" ] && die "usage: $TODO_SH addto DEST \"TODO ITEM\""
    dest="$TODO_DIR/$2"
    [ -z "$3" ] && die "usage: $TODO_SH addto DEST \"TODO ITEM\""
    shift
    shift
    input=$*

    if [ -f "$dest" ]; then
        _addto "$dest" "$input"
    else
        die "TODO: Destination file $dest does not exist."
    fi
    ;;

"append" | "app" )
    errmsg="usage: $TODO_SH append ITEM# \"TEXT TO APPEND\""
    shift; item=$1; shift
    getTodo "$item"

    if [[ -z "$1" && $TODOTXT_FORCE = 0 ]]; then
        read -p "Append: " -e -r input
    else
        input=$*
    fi
    case "$input" in
      [$SENTENCE_DELIMITERS]*)  appendspace=;;
      *)                        appendspace=" ";;
    esac
    cleaninput "for sed"

    if sed -i.bak "${item} s|^.*|&${appendspace}${input}|" "$TODO_FILE"; then
        if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
            getNewtodo "$item"
            echo "$item $newtodo"
    fi
    else
        die "TODO: Error appending task $item."
    fi
    ;;

"archive" )
    # defragment blank lines
    sed -i.bak -e '/./!d' "$TODO_FILE"
    [ "$TODOTXT_VERBOSE" -gt 0 ] && grep "^x " "$TODO_FILE"
    grep "^x " "$TODO_FILE" >> "$DONE_FILE"
    sed -i.bak '/^x /d' "$TODO_FILE"
    if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
        echo "TODO: $TODO_FILE archived."
    fi
    ;;

"del" | "rm" )
    # replace deleted line with a blank line when TODOTXT_PRESERVE_LINE_NUMBERS is 1
    errmsg="usage: $TODO_SH del ITEM# [TERM]"
    item=$2
    getTodo "$item"

    if [ -z "$3" ]; then
        if confirm "Delete '$todo'"; then
            if [ $TODOTXT_PRESERVE_LINE_NUMBERS = 0 ]; then
                # delete line (changes line numbers)
                sed -i.bak -e "${item}s/^.*//" -e '/./!d' "$TODO_FILE"
            else
                # leave blank line behind (preserves line numbers)
                sed -i.bak -e "${item}s/^.*//" "$TODO_FILE"
            fi
            if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
                echo "$item $todo"
                echo "TODO: $item deleted."
            fi
        else
            die "TODO: No tasks were deleted."
        fi
    else
        sed -i.bak \
            -e "${item}s/^\((.) \)\{0,1\} *$3 */\1/g" \
            -e "${item}s/ *$3 *\$//g" \
            -e "${item}s/  *$3 */ /g" \
            -e "${item}s/ *$3  */ /g" \
            -e "${item}s/$3//g" \
            "$TODO_FILE"
        getNewtodo "$item"
        if [ "$todo" = "$newtodo" ]; then
            [ "$TODOTXT_VERBOSE" -gt 0 ] && echo "$item $todo"
            die "TODO: '$3' not found; no removal done."
        fi
        if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
            echo "$item $todo"
            echo "TODO: Removed '$3' from task."
            echo "$item $newtodo"
        fi
    fi
    ;;

"depri" | "dp" )
    errmsg="usage: $TODO_SH depri ITEM#[, ITEM#, ITEM#, ...]"
    shift;
    [ $# -eq 0 ] && die "$errmsg"

    # Split multiple depri's, if comma separated change to whitespace separated
    # Loop the 'depri' function for each item
    status=0
    for item in ${*//,/ }; do
        getTodo "$item"

	if [[ "$todo" = \(?\)\ * ]]; then
	    sed -i.bak -e "${item}s/^(.) //" "$TODO_FILE"
	    if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
		getNewtodo "$item"
		echo "$item $newtodo"
		echo "TODO: $item deprioritized."
	    fi
	else
	    echo >&2 "TODO: $item is not prioritized."
	    status=1
	fi
    done
    exit $status
    ;;

"do" | "done" )
    errmsg="usage: $TODO_SH do ITEM#[, ITEM#, ITEM#, ...]"
    # shift so we get arguments to the do request
    shift;
    [ "$#" -eq 0 ] && die "$errmsg"

    # Split multiple do's, if comma separated change to whitespace separated
    # Loop the 'do' function for each item
    status=0
    for item in ${*//,/ }; do
        getTodo "$item"

        # Check if this item has already been done
        if [ "${todo:0:2}" != "x " ]; then
            now=$(date '+%Y-%m-%d')
            # remove priority once item is done
            sed -i.bak "${item}s/^(.) //" "$TODO_FILE"
            sed -i.bak "${item}s|^|x $now |" "$TODO_FILE"
            if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
                getNewtodo "$item"
                echo "$item $newtodo"
                echo "TODO: $item marked as done."
        fi
        else
            echo >&2 "TODO: $item is already marked done."
            status=1
        fi
    done

    if [ $TODOTXT_AUTO_ARCHIVE = 1 ]; then
        # Recursively invoke the script to allow overriding of the archive
        # action.
        "$TODO_FULL_SH" archive || status=$?
    fi
    exit $status
    ;;

"help" )
    shift  ## Was help; new $1 is first help topic / action name
    if [ $# -gt 0 ]; then
        # Don't use PAGER here; we don't expect much usage output from one / few actions.
        actionUsage "$@"
    else
        if [ -t 1 ] ; then # STDOUT is a TTY
            if command -v "${PAGER:-less}" >/dev/null 2>&1; then
                # we have a working PAGER (or less as a default)
                help | "${PAGER:-less}" && exit 0
            fi
        fi
        help # just in case something failed above, we go ahead and just spew to STDOUT
    fi
    ;;

"shorthelp" )
    if [ -t 1 ] ; then # STDOUT is a TTY
        if command -v "${PAGER:-less}" >/dev/null 2>&1; then
            # we have a working PAGER (or less as a default)
            shorthelp | "${PAGER:-less}" && exit 0
        fi
    fi
    shorthelp # just in case something failed above, we go ahead and just spew to STDOUT
    ;;

"list" | "ls" )
    shift  ## Was ls; new $1 is first search term
    _list "$TODO_FILE" "$@"
    ;;

"listall" | "lsa" )
    shift  ## Was lsa; new $1 is first search term

    TOTAL=$( sed -n '$ =' "$TODO_FILE" )
    PADDING=${#TOTAL}

    post_filter_command="${post_filter_command:-}${post_filter_command:+ | }awk -v TOTAL=$TOTAL -v PADDING=$PADDING '{ \$1 = sprintf(\"%\" PADDING \"d\", (\$1 > TOTAL ? 0 : \$1)); print }' "
    cat "$TODO_FILE" "$DONE_FILE" | TODOTXT_VERBOSE=0 _format '' "$PADDING" "$@"

    if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
        TDONE=$( sed -n '$ =' "$DONE_FILE" )
        TASKNUM=$(TODOTXT_PLAIN=1 TODOTXT_VERBOSE=0 _format "$TODO_FILE" 1 "$@" | sed -n '$ =')
        DONENUM=$(TODOTXT_PLAIN=1 TODOTXT_VERBOSE=0 _format "$DONE_FILE" 1 "$@" | sed -n '$ =')
        echo "--"
        echo "$(getPrefix "$TODO_FILE"): ${TASKNUM:-0} of ${TOTAL:-0} tasks shown"
        echo "$(getPrefix "$DONE_FILE"): ${DONENUM:-0} of ${TDONE:-0} tasks shown"
        echo "total $((TASKNUM + DONENUM)) of $((TOTAL + TDONE)) tasks shown"
    fi
    ;;

"listfile" | "lf" )
    shift  ## Was listfile, next $1 is file name
    if [ $# -eq 0 ]; then
        [ "$TODOTXT_VERBOSE" -gt 0 ] && echo "Files in the todo.txt directory:"
        cd "$TODO_DIR" && ls -1 -- *.txt
    else
        FILE="$1"
        shift  ## Was filename; next $1 is first search term

        _list "$FILE" "$@"
    fi
    ;;

"listcon" | "lsc" )
    shift
    listWordsWithSigil '@' "$@"
    ;;

"listproj" | "lsprj" )
    shift
    listWordsWithSigil '+' "$@"
    ;;

"listpri" | "lsp" )
    shift ## was "listpri", new $1 is priority to list or first TERM

    pri=$(set -o pipefail; printf "%s\n" "$1" | grep '^\([A-Za-z]\|[A-Za-z]-[A-Za-z]\|[A-Z][A-Z-]*[A-Z]\)$' | tr '[:lower:]' '[:upper:]') && shift || pri="A-Z"
    post_filter_command="${post_filter_command:-}${post_filter_command:+ | }grep '^ *[0-9]\+ ([${pri}]) '"
    _list "$TODO_FILE" "$@"
    ;;

"move" | "mv" )
    # replace moved line with a blank line when TODOTXT_PRESERVE_LINE_NUMBERS is 1
    errmsg="usage: $TODO_SH mv ITEM# DEST [SRC]"
    item=$2
    dest="$TODO_DIR/$3"
    src="$TODO_DIR/$4"

    [ -z "$4" ] && src="$TODO_FILE"
    [ -z "$dest" ] && die "$errmsg"

    [ -f "$src" ] || die "TODO: Source file $src does not exist."
    [ -f "$dest" ] || die "TODO: Destination file $dest does not exist."

    getTodo "$item" "$src"
    [ -z "$todo" ] && die "$item: No such item in $src."
    if confirm "Move '$todo' from $src to $dest"; then
        if [ $TODOTXT_PRESERVE_LINE_NUMBERS = 0 ]; then
            # delete line (changes line numbers)
            sed -i.bak -e "${item}s/^.*//" -e '/./!d' "$src"
        else
            # leave blank line behind (preserves line numbers)
            sed -i.bak -e "${item}s/^.*//" "$src"
        fi
        fixMissingEndOfLine "$dest"
        echo "$todo" >> "$dest"

        if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
            echo "$item $todo"
            echo "TODO: $item moved from '$src' to '$dest'."
        fi
    else
        die "TODO: No tasks moved."
    fi
    ;;

"prepend" | "prep" )
    errmsg="usage: $TODO_SH prepend ITEM# \"TEXT TO PREPEND\""
    replaceOrPrepend 'prepend' "$@"
    ;;

"pri" | "p" )
    shift
    status=0
    while [ "$#" -gt 0 ] ; do
        item=$1
        newpri=$( printf "%s\n" "$2" | tr '[:lower:]' '[:upper:]' )

        errmsg="usage: $TODO_SH pri ITEM# PRIORITY[, ITEM# PRIORITY, ...]
note: PRIORITY must be anywhere from A to Z."

        [ "$#" -lt 2 ] && die "$errmsg"
        [[ "$newpri" = @([A-Z]) ]] || die "$errmsg"
        getTodo "$item"

        oldpri=
        if [[ "$todo" = \(?\)\ * ]]; then
            oldpri=${todo:1:1}
        fi

        if [ "$oldpri" != "$newpri" ]; then
            sed -i.bak -e "${item}s/^(.) //" -e "${item}s/^/($newpri) /" "$TODO_FILE"
        fi
        if [ "$TODOTXT_VERBOSE" -gt 0 ]; then
            getNewtodo "$item"
            echo "$item $newtodo"
            if [ "$oldpri" != "$newpri" ]; then
                if [ "$oldpri" ]; then
                    echo "TODO: $item re-prioritized from ($oldpri) to ($newpri)."
                else
                    echo "TODO: $item prioritized ($newpri)."
                fi
            fi
        fi
        if [ "$oldpri" = "$newpri" ]; then
            echo >&2 "TODO: $item already prioritized ($newpri)."
            status=1
        fi
    shift; shift
    done
    exit $status
    ;;

"replace" )
    errmsg="usage: $TODO_SH replace ITEM# \"UPDATED ITEM\""
    replaceOrPrepend 'replace' "$@"
    ;;

"report" )
    # archive first
    # Recursively invoke the script to allow overriding of the archive
    # action.
    "$TODO_FULL_SH" archive

    TOTAL=$( sed -n '$ =' "$TODO_FILE" )
    TDONE=$( sed -n '$ =' "$DONE_FILE" )
    NEWDATA="${TOTAL:-0} ${TDONE:-0}"
    LASTREPORT=$(sed -ne '$p' "$REPORT_FILE")
    LASTDATA=${LASTREPORT#* }   # Strip timestamp.
    if [ "$LASTDATA" = "$NEWDATA" ]; then
        echo "$LASTREPORT"
        [ "$TODOTXT_VERBOSE" -gt 0 ] && echo "TODO: Report file is up-to-date."
    else
        NEWREPORT="$(date +%Y-%m-%dT%T) ${NEWDATA}"
        echo "${NEWREPORT}" >> "$REPORT_FILE"
        echo "${NEWREPORT}"
        [ "$TODOTXT_VERBOSE" -gt 0 ] && echo "TODO: Report file updated."
    fi
    ;;

"deduplicate" )
    if [ $TODOTXT_PRESERVE_LINE_NUMBERS = 0 ]; then
        deduplicateSedCommand='d'
    else
        deduplicateSedCommand='s/^.*//; p'
    fi

    # To determine the difference when deduplicated lines are preserved, only
    # non-empty lines must be counted.
    originalTaskNum=$( sed -e '/./!d' "$TODO_FILE" | sed -n '$ =' )

    # Look for duplicate lines and discard the second occurrence.
    # We start with an empty hold space on the first line.  For each line:
    #   G - appends newline + hold space to the pattern space
    #   s/\n/&&/; - double up the first new line so we catch adjacent dups
    #   /^\([^\n]*\n\).*\n\1/b dedup
    #       If the first line of the hold space shows up again later as an
    #       entire line, it's a duplicate. Jump to the "dedup" label, where
    #       either of the following is executed, depending on whether empty
    #       lines should be preserved:
    #       d           - Delete the current pattern space, quit this line and
    #                     move on to the next, or:
    #       s/^.*//; p  - Clear the task text, print this line and move on to
    #                     the next.
    #   s/\n//;   - else (no duplicate), drop the doubled newline
    #   h;        - replace the hold space with the expanded pattern space
    #   P;        - print up to the first newline (that is, the input line)
    #   b         - end processing of the current line
    sed -i.bak -n \
        -e 'G; s/\n/&&/; /^\([^\n]*\n\).*\n\1/b dedup' \
        -e 's/\n//; h; P; b' \
        -e ':dedup' \
        -e "$deduplicateSedCommand" \
        "$TODO_FILE"

    newTaskNum=$( sed -e '/./!d' "$TODO_FILE" | sed -n '$ =' )
    deduplicateNum=$(( originalTaskNum - newTaskNum ))
    if [ $deduplicateNum -eq 0 ]; then
        die "TODO: No duplicate tasks found"
    else
        echo "TODO: $deduplicateNum duplicate task(s) removed"
    fi
    ;;

"listaddons" )
    if [ -d "$TODO_ACTIONS_DIR" ]; then
        cd "$TODO_ACTIONS_DIR" || exit $?
        for action in *
        do
            if [ -f "$action" ] && [ -x "$action" ]; then
                echo "$action"
            elif [ -d "$action" ] && [ -x "$action/$action" ]; then
                echo "$action"
            fi
        done
    fi
    ;;

* )
    usage;;
esac
