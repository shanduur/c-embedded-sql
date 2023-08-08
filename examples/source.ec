// example from:
//  - https://www.ibm.com/docs/en/informix-servers/12.10?topic=program-guide-demo1ec-file

#include <stdio.h>

EXEC SQL define FNAME_LEN 15;
EXEC SQL define LNAME_LEN 15;

main()
{
    EXEC SQL BEGIN DECLARE SECTION;

    char fname[FNAME_LEN + 1];
    char lname[LNAME_LEN + 1];

    EXEC SQL END DECLARE SECTION;

    printf("DEMO1 Sample ESQL Program running.\n\n");

    EXEC SQL WHENEVER ERROR STOP;
    EXEC SQL connect to 'stores7';

    EXEC SQL DECLARE democursor cursor for
        select fname, lname
        into :fname, :lname
        from customer
        where lname < 'C';

    EXEC SQL open democursor;

    for (;;)
    {
        EXEC SQL fetch democursor;
        if (strncmp(SQLSTATE, "00", 2) != 0)
            break;
        printf("%s %s\n", fname, lname);
    }

    if (strncmp(SQLSTATE, "02", 2) != 0)
        printf("SQLSTATE after fetch is %s\n", SQLSTATE);

    EXEC SQL close democursor;
    EXEC SQL free democursor;
    EXEC SQL disconnect current;

    printf("\nDEMO1 Sample Program over.\n\n");
}