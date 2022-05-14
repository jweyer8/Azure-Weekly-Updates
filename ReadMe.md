# Azure Weekly Updates

- Executable desined to gather and report data from Azure Dev Ops queries 
- run `create_report -h` for information on command line options 
- A standard use case would look something like this:
  - `create_report --query <azure devops query IDs> --org <azure devops organization> --project <azure project>`
  - This command will output a .txt file that displays the data from the provided query ID's
  - This .txt file is currently used to create a weekly status report but could easily be modified to do other things