# awk program to clean up wdiff output
# prints one line of before and after context
# turns deletes red
# turns inserts green
# http://www.sable.mcgill.ca/~cpicke/swd/README

BEGIN {
    printing = 0;     # true if we are in printing mode
    printed_last = 0; # true if we printed the last line and it was not just context
    first_match = 1;  # true if we are at the first match
    
    color_context = "\033[0m\033[37m";
    color_insert  = "\033[1m\033[32m";
    color_delete  = "\033[1m\033[31m"
    color_off     = "\033[0m\033[00m";

    printf "%s", color_context;
}

END {
    printf "%s", color_off;
}

{ 
    should_print = 0; # true if we need to print the current line and it is not context
    delete_start = gsub (/\[\-/, color_delete, $0);
    delete_end = gsub (/\-\]/, color_context, $0);
    insert_start = gsub (/{\+/, color_insert, $0); 
    insert_end = gsub (/\+}/, color_context, $0);

    # if we have any special tokens we need to print the current line
    if (delete_start > 0 ||
	delete_end > 0 ||
	insert_start > 0 ||
	insert_end > 0) 
    {
	should_print = 1;
    }
    # if there are more starts than ends we want to turn printing on
    if (delete_start + insert_start > delete_end + insert_end)
    {
	printing = 1;
    }
    # if there are less starts than ends we want to turn printing off
    if (delete_start + insert_start < delete_end + insert_end)
    {
	printing = 0;
    }
    if (printing)
    {
	should_print = 1;
    }
    if (should_print)
    {
	if (printed_last == 0)
	{
	    # print before context unless it was already after context
	    if (last_NR != context_NR)
	    {
		# print separators from the beginning of the second match
		if (!first_match)
		{
		    print "---";
		}
		print last;
	    }
	}
	print;
	first_match = 0;
	printed_last = 1;
    }
    else
    {
	# print after context
	if (printed_last == 1)
	{ 
	    context_NR = NR;
	    print;
	    printed_last = 0;
	}
    }
    last = $0;
    last_NR = NR;
}
