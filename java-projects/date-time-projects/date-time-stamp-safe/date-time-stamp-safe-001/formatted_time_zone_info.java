import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;

public class formatted_time_zone_info {

    public static String Get_current_date_timestamp() {
        ZonedDateTime now = ZonedDateTime.now();
        ZoneId tz = now.getZone();

        // Gregorian calendar parts
        String date_part = now.format(DateTimeFormatter.ofPattern("yyyy-0MM-0dd"));
        String time_part = now.format(DateTimeFormatter.ofPattern("0HH.0mm.0ss.nnnnnnnnn"));

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
            date_part, time_part, iso_year, week, weekday, now.getYear(), day_of_year
        );

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

    public static void main(String[] args) {
        String original = Get_current_date_timestamp();
        System.out.println(original); // Step 1: original timestamp

        String no_slash = replace_slash(original);
        System.out.println(no_slash); // Step 2: slash replaced

        String safe = replace_special_chars(no_slash);
        System.out.println(safe); // Step 3: everything underscored
    }
}