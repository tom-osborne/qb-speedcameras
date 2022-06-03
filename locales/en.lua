local Translations = {
    error = {},
    success = {},
    info = {
        mail_sender = "LSPD Office",
        mail_subject = "Speeding Fine Notice",
        mail_msg = "You were caught speeding. The state has issued you a fine. <br /><br /> Speed limit: %{maxSpeed}%{speedUnit} <br /> <strong>Fine: $%{fineAmount}</strong>"
    }

}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})