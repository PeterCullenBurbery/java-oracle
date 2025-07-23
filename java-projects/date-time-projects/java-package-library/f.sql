CREATE OR REPLACE AND COMPILE JAVA SOURCE NAMED "formatted_time_zone_info" AS
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;

public class formatted_time_zone_info {

    public static String Get_current_date_timestamp() {
        ZonedDateTime now = ZonedDateTime.now();
        ZoneId tz = now.getZone();

        // Nanoseconds pattern using repeat
        String nanoseconds_pattern = "n".repeat(9);

        // Gregorian calendar parts
        String date_part = now.format(DateTimeFormatter.ofPattern("yyyy-0MM-0dd"));
        String time_part = now.format(DateTimeFormatter.ofPattern("0HH.0mm.0ss." + nanoseconds_pattern));

        // ISO week info
        WeekFields wf = WeekFields.ISO;
        int week = now.get(wf.weekOfWeekBasedYear());
        int weekday = now.get(wf.dayOfWeek());
        int iso_year = now.get(wf.weekBasedYear());

        // Ordinal day (day of year)
        int day_of_year = now.getDayOfYear();

        // Compose output
        String output = String.format(
                "%s %s %04d-W%03d-%03d %04d-%03d",
                date_part, time_part, iso_year, week, weekday, now.getYear(), day_of_year);

        // Insert time zone ID between parts
        output = output.replace(time_part, time_part + " " + tz);

        return output;
    }

    public static String replace_slash(String input) {
        return input.replace("/", " slash ");
    }

    public static String replace_special_chars(String input) {
        String[] targets = { "-", " ", "." };
        for (String ch : targets) {
            input = input.replace(ch, "_");
        }
        return input;
    }

    public static String safetime_timestamp_of_underscore() {
        return replace_special_chars(replace_slash(Get_current_date_timestamp()));
    }

    public static String user_timestamped() {
        return "user_" + safetime_timestamp_of_underscore();
    }
}
/

CREATE OR REPLACE PACKAGE date_time_utils AS
    FUNCTION get_timestamp RETURN VARCHAR2;
    FUNCTION replace_slash(p_input IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION replace_special_chars(p_input IN VARCHAR2) RETURN VARCHAR2;
    FUNCTION safetime_timestamp_of_underscore RETURN VARCHAR2;
    FUNCTION user_timestamped RETURN VARCHAR2;
END date_time_utils;
/

CREATE OR REPLACE PACKAGE BODY date_time_utils AS

    FUNCTION get_timestamp RETURN VARCHAR2 IS
    BEGIN
        RETURN get_current_date_timestamp;
    END;

    FUNCTION replace_slash(p_input IN VARCHAR2) RETURN VARCHAR2 AS LANGUAGE JAVA
    NAME 'formatted_time_zone_info.replace_slash(java.lang.String) return java.lang.String';

    FUNCTION replace_special_chars(p_input IN VARCHAR2) RETURN VARCHAR2 AS LANGUAGE JAVA
    NAME 'formatted_time_zone_info.replace_special_chars(java.lang.String) return java.lang.String';

    FUNCTION safetime_timestamp_of_underscore RETURN VARCHAR2 AS LANGUAGE JAVA
    NAME 'formatted_time_zone_info.safetime_timestamp_of_underscore() return java.lang.String';

    FUNCTION user_timestamped RETURN VARCHAR2 AS LANGUAGE JAVA
    NAME 'formatted_time_zone_info.user_timestamped() return java.lang.String';

END date_time_utils;
/

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- date_time_utils.get_timestamp ---');
    DBMS_OUTPUT.PUT_LINE(date_time_utils.get_timestamp);

    DBMS_OUTPUT.PUT_LINE('--- date_time_utils.replace_slash ---');
    DBMS_OUTPUT.PUT_LINE(date_time_utils.replace_slash(date_time_utils.get_timestamp));

    DBMS_OUTPUT.PUT_LINE('--- date_time_utils.replace_special_chars ---');
    DBMS_OUTPUT.PUT_LINE(date_time_utils.replace_special_chars(date_time_utils.replace_slash(date_time_utils.get_timestamp)));

    DBMS_OUTPUT.PUT_LINE('--- date_time_utils.safetime_timestamp_of_underscore ---');
    DBMS_OUTPUT.PUT_LINE(date_time_utils.safetime_timestamp_of_underscore);

    DBMS_OUTPUT.PUT_LINE('--- date_time_utils.user_timestamped ---');
    DBMS_OUTPUT.PUT_LINE(date_time_utils.user_timestamped);
END;
/