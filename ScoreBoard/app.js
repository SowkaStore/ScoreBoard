window.addEventListener('message', (e) => {
    var action = e.data.action
    var data = e.data

    switch (action) {
        case 'open': {
            $(".scoreboard").css("display", "block")
            break
        }

        case 'close': {
            $('.scoreboard').hide()
            break
        }

        case 'update': {
            $('#policeid').html(data.data['police'])
            $('#ambulanceid').html(data.data['ambulance'])
            $('#mechanicid').html(data.data['mechanic'])
            $('#playersid').html(data.data['players'])
            
            $("#playerid").html(data.data['id'])
            $("#player-job").html(data.data['job'])
            $("#player-label").html(data.data['name'])
            break
        }

        case 'setuID': {
            $("#uID").html(data.uID)
            break
        }

        default: {
            break
        }
    }
})
