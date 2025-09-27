#!/usr/bin/env node

/**
 * Simple JWT token expiration checker
 * Usage: node check-jwt.js <token>
 */

function checkJWTExpiration(token) {
  try {
    // Split the JWT into its three parts
    const parts = token.split(".");

    if (parts.length !== 3) {
      throw new Error(
        "Invalid JWT format. Expected 3 parts separated by dots."
      );
    }

    // Decode the payload (second part)
    const payload = parts[1];

    // Add padding if needed for base64 decoding
    const paddedPayload = payload + "=".repeat((4 - (payload.length % 4)) % 4);

    // Decode base64url to JSON
    const decodedPayload = JSON.parse(
      Buffer.from(paddedPayload, "base64").toString()
    );

    // Check if exp claim exists
    if (!decodedPayload.exp) {
      console.log("❌ No expiration claim (exp) found in token");
      return false;
    }

    // Get current timestamp (in seconds)
    const currentTime = Math.floor(Date.now() / 1000);

    // Check if token is expired
    const isExpired = currentTime >= decodedPayload.exp;

    if (isExpired) {
      console.log("❌ Token is EXPIRED");
      console.log(
        `   Expired at: ${new Date(decodedPayload.exp * 1000).toISOString()}`
      );
      console.log(`   Current time: ${new Date().toISOString()}`);
    } else {
      console.log("✅ Token is VALID");
      console.log(
        `   Expires at: ${new Date(decodedPayload.exp * 1000).toISOString()}`
      );
      console.log(`   Current time: ${new Date().toISOString()}`);
      console.log(
        `   Time remaining: ${Math.floor(
          (decodedPayload.exp - currentTime) / 60
        )} minutes`
      );
    }

    return !isExpired;
  } catch (error) {
    console.error("❌ Error checking JWT:", error.message);
    return false;
  }
}

// Main execution
function main() {
  const token = process.argv[2];

  if (!token) {
    console.error("❌ Please provide a JWT token as an argument");
    console.log("Usage: node check-jwt.js <token>");
    process.exit(1);
  }

  const isValid = checkJWTExpiration(token);
  process.exit(isValid ? 0 : 1);
}

// Run if this file is executed directly
if (require.main === module) {
  main();
}

module.exports = { checkJWTExpiration };
