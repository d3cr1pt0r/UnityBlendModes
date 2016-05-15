fixed4 additive(fixed4 color_back, fixed4 color_front) {
	return color_back + color_front;
}

fixed4 multiply(fixed4 color_back, fixed4 color_front) {
	return fixed4(color_back.r * color_front.r, color_back.g * color_front.g, color_back.b * color_front.b, color_back.a * color_front.a);
}

fixed4 divide(fixed4 color_back, fixed4 color_front) {
	return fixed4(color_back.r / color_front.r, color_back.g / color_front.g, color_back.b / color_front.b, color_back.a / color_front.a);
}

fixed4 subtract(fixed4 color_back, fixed4 color_front) {
	return color_back - color_front;
}

fixed4 overlay(fixed4 color_back, fixed4 color_front) {
	return lerp(2 * color_back * color_front, 1 - 2 * (1 - color_back) * (1 - color_front), step(length(color_back.rgb), 0.5));
}

fixed4 darken(fixed4 color_back, fixed4 color_front) {
	return fixed4(min(color_back.r, color_front.r), min(color_back.g, color_front.g), min(color_back.b, color_front.b), min(color_back.a, color_front.a));
}

fixed4 lighten(fixed4 color_back, fixed4 color_front) {
	return fixed4(max(color_back.r, color_front.r), max(color_back.g, color_front.g), max(color_back.b, color_front.b), max(color_back.a, color_front.a));
}

fixed4 difference(fixed4 color_back, fixed4 color_front) {
	return fixed4(abs(color_back.r - color_front.r), abs(color_back.g - color_front.g), abs(color_back.b - color_front.b), abs(color_back.a - color_front.a));
}

fixed4 hard_light(fixed4 color_back, fixed4 color_front) {
	return lerp(2 * color_front * color_back, 1 - 2 * (1 - color_front) * (1 - color_back), step(length(color_front.rgb), 0.5));
}

fixed4 screen(fixed4 color_back, fixed4 color_front) {
	return 1 - (1 - color_back) * (1 - color_front);
}

fixed4 color_dodge(fixed4 color_back, fixed4 color_front) {
	return color_back / (1.0 - color_front);
}

fixed4 color_burn(fixed4 color_back, fixed4 color_front) {
	return 1 - (1 - color_back) / color_front;
}

fixed4 linear_burn(fixed4 color_back, fixed4 color_front) {
	return (color_back + color_front) - 1;
}