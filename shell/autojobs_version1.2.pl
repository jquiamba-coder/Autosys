#!/usr/bin/perl
use strict;
use feature "switch";

# Reads standard JIL file and exports as Tab-Separated.

my $autosys_jil = "/opt/cascripts/shell/autosystools/autotool/export/ConsolidatedList.jil";
my $autosys_jilout = "/opt/cascripts/shell/autosystools/autotool/export/autorepall.tsv";
my $job_count = 0;

# OutPut File Header
my $output_header = "count	type	name	no. of conditions	conditions types	alarm_if_fail	alarm_if_terminated	application	box_name	box_success	box_terminator	command	condition	date_conditions	days_of_week	description	exclude_calendar	group	insert_job	job_terminator	machine	max_run_alarm	min_run_alarm	must_complete_times	must_start_times	n_retrys	notification_emailaddress	notification_msg	notification_template	owner	permission	priority	profile	remote_command	remote_target	resources	run_calendar	run_window	send_notification	service_desk	start_mins	start_times	std_err_file	std_out_file	success_codes	svcdesk_attr	svcdesk_desc	svcdesk_imp	svcdesk_pri	svcdesk_sev	term_run_time	timezone	watch_file	watch_file_min_size	watch_interval";

# Open file IN
open (my $autosys_jilfile, "<", $autosys_jil) or EXIT_FATAL ("Can't open $autosys_jil: $!");

# Open file OUT
open (my $autosys_jiloutfile, ">", $autosys_jilout) or EXIT_FATAL ("Can't open $autosys_jilout: $!");

# Write Header to file
print $autosys_jiloutfile "$output_header\n";

# Autosys Objects
my $object_alarm_if_fail = "";
my $object_alarm_if_terminated = "";
my $object_application = "";
my $object_box_name = "";
my $object_box_success = "";
my $object_box_terminator = "";
my $object_command = "";
my $object_condition = "";
my $object_date_conditions = "";
my $object_days_of_week = "";
my $object_description = "";
my $object_exclude_calendar = "";
my $object_group = "";
my $object_insert_job = "";
my $object_job_terminator = "";
my $object_machine = "";
my $object_max_run_alarm = "";
my $object_min_run_alarm = "";
my $object_must_complete_times = "";
my $object_must_start_times = "";
my $object_n_retrys = "";
my $object_notification_emailaddress = "";
my $object_notification_msg = "";
my $object_notification_template = "";
my $object_owner = "";
my $object_permission = "";
my $object_priority = "";
my $object_profile = "";
my $object_remote_command = "";
my $object_remote_target = "";
my $object_resources = "";
my $object_run_calendar = "";
my $object_run_window = "";
my $object_send_notification = "";
my $object_service_desk = "";
my $object_start_mins = "";
my $object_start_times = "";
my $object_std_err_file = "";
my $object_std_out_file = "";
my $object_success_codes = "";
my $object_svcdesk_attr = "";
my $object_svcdesk_desc = "";
my $object_svcdesk_imp = "";
my $object_svcdesk_pri = "";
my $object_svcdesk_sev = "";
my $object_term_run_time = "";
my $object_timezone = "";
my $object_watch_file = "";
my $object_watch_file_min_size = "";
my $object_watch_interval = "";
	
# Calculated Objects
my $job_type = "";
my $job_condition_count = 0;
my $job_condition_types = "";
    
# Loop through File
while (my $line = <$autosys_jilfile>) {
	chomp $line;
	my ($object, $data) = split (":", $line, 2);
	chomp $object if (length $object);
	chomp $data if (length $data);
	
	# Remove Start and Trailing Spaces
	$object =~ s/^\s+|\s+$// if (length $object);
	$data =~ s/^\s+|\s+$// if (length $data);
	
	# Remove Carriage Returns
        $object =~ s/\r//g if (length $object);
	$data =~ s/\r//g if (length $data);
		
	given($object) {
		when ("insert_job") { 
			# Print to file if next insert_job found.
			if ($job_count > 0) {
				# Output to File and reset variables
				print "$job_count: Job: $object_insert_job Type: $job_type CC: $job_condition_count\n";
				print $autosys_jiloutfile "$job_count	$job_type	$object_insert_job	$job_condition_count	$job_condition_types	$object_alarm_if_fail	$object_alarm_if_terminated	$object_application	$object_box_name	$object_box_success	$object_box_terminator	$object_command	$object_condition	$object_date_conditions	$object_days_of_week	$object_description	$object_exclude_calendar	$object_group	$object_insert_job	$object_job_terminator	$object_machine	$object_max_run_alarm	$object_min_run_alarm	$object_must_complete_times	$object_must_start_times	$object_n_retrys	$object_notification_emailaddress	$object_notification_msg	$object_notification_template	$object_owner	$object_permission	$object_priority	$object_profile	$object_remote_command	$object_remote_target	$object_resources	$object_run_calendar	$object_run_window	$object_send_notification	$object_service_desk	$object_start_mins	$object_start_times	$object_std_err_file	$object_std_out_file	$object_success_codes	$object_svcdesk_attr	$object_svcdesk_desc	$object_svcdesk_imp	$object_svcdesk_pri	$object_svcdesk_sev	$object_term_run_time	$object_timezone	$object_watch_file	$object_watch_file_min_size	$object_watch_interval\n";
				$object_alarm_if_fail = "";
				$object_alarm_if_terminated = "";
				$object_application = "";
				$object_box_name = "";
				$object_box_success = "";
				$object_box_terminator = "";
				$object_command = "";
				$object_condition = "";
				$object_date_conditions = "";
				$object_days_of_week = "";
				$object_description = "";
				$object_exclude_calendar = "";
				$object_group = "";
				$object_insert_job = "";
				$object_job_terminator = "";
				$object_machine = "";
				$object_max_run_alarm = "";
				$object_min_run_alarm = "";
				$object_must_complete_times = "";
				$object_must_start_times = "";
				$object_n_retrys = "";
				$object_notification_emailaddress = "";
				$object_notification_msg = "";
				$object_notification_template = "";
				$object_owner = "";
				$object_permission = "";
				$object_priority = "";
				$object_profile = "";
				$object_remote_command = "";
				$object_remote_target = "";
				$object_resources = "";
				$object_run_calendar = "";
				$object_run_window = "";
				$object_send_notification = "";
				$object_service_desk = "";
				$object_start_mins = "";
				$object_start_times = "";
				$object_std_err_file = "";
				$object_std_out_file = "";
				$object_success_codes = "";
				$object_svcdesk_attr = "";
				$object_svcdesk_desc = "";
				$object_svcdesk_imp = "";
				$object_svcdesk_pri = "";
				$object_svcdesk_sev = "";
				$object_term_run_time = "";
				$object_timezone = "";
				$object_watch_file = "";
				$object_watch_file_min_size = "";
				$object_watch_interval = "";
				
				$job_type = "";
				$job_condition_count = 0;
				$job_condition_types = "";
			}
			# Split & Cleanup Insert Job
			my ($data_name, $data_type) = split (":", $data, 2);
			$data_name =~ s/ .*//;
			$data_name =~ s/^\s+|\s+$//;
			$data_type =~ s/^\s+|\s+$//;
			$object_insert_job = $data_name;
			$job_type = $data_type;
			++$job_count;
		}
		when ("alarm_if_fail") { $object_alarm_if_fail = $data;}
		when ("alarm_if_terminated") { $object_alarm_if_terminated = $data;}
		when ("application") { $object_application = $data;}
		when ("box_name") { $object_box_name = $data;}
		when ("box_success") { $object_box_success = $data;}
		when ("box_terminator") { $object_box_terminator = $data;}
		when ("command") { $object_command = $data;}
		when ("condition") { 
			$object_condition = $data;
			$job_condition_count = 1;
			# Count number of | and & in conditions
			my @countcc;
			@countcc = $data =~ /&|\|/g;
			my $cc = scalar @countcc;
			$job_condition_count = $job_condition_count + $cc;
			# find condition types in condition data i.e. d(
			$job_condition_types = $job_condition_types . "D" if ($object_condition =~ m/d\(/ );
			$job_condition_types = $job_condition_types . "F" if ($object_condition =~ m/f\(/ );
			$job_condition_types = $job_condition_types . "N" if ($object_condition =~ m/n\(/ );
			$job_condition_types = $job_condition_types . "S" if ($object_condition =~ m/s\(/ );
			$job_condition_types = $job_condition_types . "T" if ($object_condition =~ m/t\(/ );
			$job_condition_types = $job_condition_types . "V" if ($object_condition =~ m/v\(/ );
		}
		when ("date_conditions") { $object_date_conditions = $data;}
		when ("days_of_week") { $object_days_of_week = $data;}
		when ("description") { $object_description = $data;}
		when ("exclude_calendar") { $object_exclude_calendar = $data;}
		when ("group") { $object_group = $data;}
		when ("job_terminator") { $object_job_terminator = $data;}
		when ("machine") { $object_machine = $data;}
		when ("max_run_alarm") { $object_max_run_alarm = $data;}
		when ("min_run_alarm") { $object_min_run_alarm = $data;}
		when ("must_complete_times") { $object_must_complete_times = $data;}
		when ("must_start_times") { $object_must_start_times = $data;}
		when ("n_retrys") { $object_n_retrys = $data;}
		when ("notification_emailaddress") { $object_notification_emailaddress = $data;}
		when ("notification_msg") { $object_notification_msg = $data;}
		when ("notification_template") { $object_notification_template = $data;}
		when ("owner") { $object_owner = $data;}
		when ("permission") { $object_permission = $data;}
		when ("priority") { $object_priority = $data;}
		when ("profile") { $object_profile = $data;}
		when ("remote_command") { $object_remote_command = $data;}
		when ("remote_target") { $object_remote_target = $data;}
		when ("resources") { $object_resources = $data;}
		when ("run_calendar") { $object_run_calendar = $data;}
		when ("run_window") { $object_run_window = $data;}
		when ("send_notification") { $object_send_notification = $data;}
		when ("service_desk") { $object_service_desk = $data;}
		when ("start_mins") { $object_start_mins = $data;}
		when ("start_times") { $object_start_times = $data;}
		when ("std_err_file") { $object_std_err_file = $data;}
		when ("std_out_file") { $object_std_out_file = $data;}
		when ("success_codes") { $object_success_codes = $data;}
		when ("svcdesk_attr") { $object_svcdesk_attr = $data;}
		when ("svcdesk_desc") { $object_svcdesk_desc = $data;}
		when ("svcdesk_imp") { $object_svcdesk_imp = $data;}
		when ("svcdesk_pri") { $object_svcdesk_pri = $data;}
		when ("svcdesk_sev") { $object_svcdesk_sev = $data;}
		when ("term_run_time") { $object_term_run_time = $data;}
		when ("timezone") { $object_timezone = $data;}
		when ("watch_file") { $object_watch_file = $data;}
		when ("watch_file_min_size") { $object_watch_file_min_size = $data;}
		when ("watch_interval") { $object_watch_interval = $data;}
		when ("alarm_if_fail") { $object_alarm_if_fail = $data;}
	}
}
close $autosys_jil;
close $autosys_jiloutfile;

