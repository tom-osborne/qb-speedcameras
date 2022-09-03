local Translations = {
    alert = {
        caught_speeding = "A vehicle with plate: %{vehicle_plate} was caught doing %{veh_speed} in a %{max_speed} %{speedUnit} zone!"
    },
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