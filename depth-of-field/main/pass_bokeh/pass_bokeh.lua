local M = {}

M.init = function()
	local rt_width = render.get_window_width() / 2
	local rt_height = render.get_window_height() / 2

	local color_params = {
		format = render.FORMAT_RGBA32F,
		width  = rt_width,
		height = rt_height,
	}

	M.rt 		= render.render_target({[render.BUFFER_COLOR_BIT] = color_params})
	M.width     = rt_width
	M.height    = rt_height
	M.predicate = render.predicate({"pass_bokeh"})
	M.constants = render.constant_buffer()
end

M.render = function(state, target_prefilter)
	M.constants.u_bokeh_parameters = vmath.vector4(M.width, M.height, state.camera_params.bokeh_radius, 0)
	
	render.set_render_target(M.rt)
	render.set_viewport(0, 0, M.width, M.height)

	render.set_view(vmath.matrix4())
	render.set_projection(vmath.matrix4())

	render.disable_state(render.STATE_DEPTH_TEST)
	render.disable_state(render.STATE_CULL_FACE)

	render.enable_texture("texture_scene", target_prefilter, render.BUFFER_COLOR0_BIT)

	render.draw(M.predicate, { constants = M.constants })

	render.set_render_target(render.RENDER_TARGET_DEFAULT)

	render.disable_texture("texture_scene")
end

M.target = function()
	return M.rt
end

return M