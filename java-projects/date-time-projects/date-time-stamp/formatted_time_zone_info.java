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
}