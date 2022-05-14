from appscript import app, k

outlook = app('Microsoft Outlook')
report = open('report.txt', 'r').read()

msg = outlook.make(
    new=k.outgoing_message,
    with_properties={
        k.subject: "Jared's Weekly report",
        k.content: report })

msg.make(
    new=k.recipient,
    with_properties={
        k.email_address: {
            k.address: 'apexsealig@microsoft.com'}})

msg.open()
msg.activate()