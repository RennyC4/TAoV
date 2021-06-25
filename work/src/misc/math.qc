/*
 * misc_math.qc
 *
 * Author: Joshua Skelton joshua.skelton@gmail.com
 *
 * A collection of helpful math functions.
 */

// Forward declarations
float(float value, float minValue, float maxValue) clamp;
float(float a, float b) mod;
float(float x) sign;
float(float value, float minValue, float maxValue) wrap;

/*
 * clamp
 *
 * Limits the given value to the given range.
 *
 * value: A number
 *
 * minValue: The minimum value of the range
 *
 * maxValue: The maximum value of the range
 *
 * Returns: A number within the given range.
 */
float(float value, float minValue, float maxValue) clamp = {
    if (value < minValue) {
        return minValue;
    }
    else if (value > maxValue) {
        return maxValue;
    }

    return value;
};
 
/*
 * sign
 *
 * Returns an indication of the sign of the given number.
 *
 * x: A number
 *
 * Returns: -1 if x < 0, 0 if x == 0, 1 if x > 0.
 */
float(float x) sign = {
    if (x > 0) {
        return 1;
    }
    else if (x < 0) {
        return -1;
    }

    return 0;
};

/*
 * wrap
 *
 * Limits the given value to the given range and will wrap the value to the
 * the other end of the range if exceeded.
 *
 * value: A number
 *
 * minValue: The minimum value of the range
 *
 * maxValue: The maximum value of the range
 *
 * Returns: A number within the given range.
 */
float(float value, float minValue, float maxValue) wrap = {
    local float range = maxValue - minValue;

    return mod(value - minValue, range + 1) + minValue;
};

/*
 *
 * angle difference
 *
 * from DOOMBRINGER
 *
 */

float(float start, float end) angle_diff =
{
    // result = how much to turn to go from 'start' to 'end'
    // result ranges from -180 to +180

    local float D = anglemod(end) - anglemod(start);

    if (D >  180) D = D - 360;
    if (D < -180) D = D + 360;

    return D;
};