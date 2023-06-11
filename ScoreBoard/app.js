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
        }

        default: {
            break
        }
    }
})

const sendRequest = (action, data = {}, cb) => {
    if (typeof(GetParentResourceName) === "function") {
        $.post(`https://${GetParentResourceName()}/${action}`, JSON.stringify(data), (response, status) => {
            if (typeof(cb) === "function") {
                cb(status === "success", response)
            }
        })
    } else {
        console.log(action)
        console.log(JSON.stringify(data, null, 4))
    }
}