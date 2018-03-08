show_next_image_ken_burns = () ->
	$.get '/next', (data) ->
		info = eval("(" + data + ")");

		if info.title
				$("#title").html(info.title)
				$("#title").show()
			else
				$("#title").hide()

		if window.fade_state == "front"
			divblock = $("#back")
		else
			divblock = $("#front")

		relation_viewport = window.innerWidth / window.innerHeight
		relation_image = info.width / info.height

		xfactor = Math.random() < 0.5 ? 1 : -1
		yfactor = Math.random() < 0.5 ? 1 : -1

		if relation_image > relation_viewport
			back_height = window.innerHeight + 50
			back_width = Math.floor(info.width * (window.innerHeight/info.height))
			width_diff = window.innerWidth - back_width
			xoffset = Math.floor(width_diff / 4)
			yoffset = -25 + (xfactor*25)
			xmove = xoffset + Math.floor(width_diff / 2)
			ymove = 0
		else
			back_width = window.innerWidth + 50
			back_height = Math.floor(info.height * (window.innerWidth/info.width))
			height_diff = back_height - window.innerHeight
			xoffset = -25 + (25 * xfactor)
			yoffset = - Math.floor( height_diff * (0.5 + (0.25*yfactor)) )
			ymove = - yfactor * Math.floor(height_diff / 4)
			xmove = -50 * xfactor

		degrees = info.degrees
		if degrees == 90 || degrees == 270
			temp = back_width
			back_width = back_height
			back_height = temp

		divblock.css("width", window.innerWidth)
		divblock.css("height", window.innerHeight)
		divblock.css("background-image", "url("+info.filename+")")

		divblock.css("background-size", back_width+"px "+back_height+"px")
		divblock.css("background-repeat", "no-repeat")
		divblock.css("background-position", xoffset+"px "+yoffset+"px")

		divblock.css("-webkit-transform", "rotate("+degrees+"deg)")

		if window.fade_state == "front"
			$('#front').fadeOut(2000)
			window.fade_state = "back"
		else
			$('#front').fadeIn(2000)
			window.fade_state = "front"

		#divblock.animate({
		#		"background-position-x": xmove,
		#		"background-position-y": ymove,
		#	}, 7000)

show_next_image = () ->
	$.get '/next', (data) ->
		info = eval("(" + data + ")");

		if window.fade_state == "front"
			divblock = $("#back")
		else
			divblock = $("#front")

		divblock.css("width", window.innerWidth)
		divblock.css("height", window.innerHeight)
		divblock.find("img").attr("src", info.filename)

		if window.fade_state == "front"
			$('#front').fadeOut(2000)
			window.fade_state = "back"
		else
			$('#front').fadeIn(2000)
			window.fade_state = "front"

show_next_image_new = () ->
  $.get '/next', (data) ->
    info = eval("(" + data + ")")
    timer = null
    old = $(".container")

    container = $('<div/>', {
      class: 'container',
    }).hide()

    image = $("<img />", {
      src: info.filename
    })

    container.append(image)

    container.appendTo('body').fadeIn(2000, () ->
      old.hide()
      old.remove()
    )

    window.clearTimeout(timer)
    timer = window.setTimeout(show_next_image_new, 5000)


$(document).ready( ->
	#$("#title").html("Lade Slideshow...")
  $("#title").hide()
	window.fade_state = "front"

	show_next_image_new()

	#window.setInterval(show_next_image_new, 6000)
)