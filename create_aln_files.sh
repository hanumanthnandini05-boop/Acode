#!/bin/bash
# Tiny ALN Online project generator
# Works on Termux or any Bash terminal (mobile or PC)

echo "Creating ALN_online_ready folder structure..."

mkdir -p ALN_online_ready/app/src/main/java/com/aln/chat
mkdir -p ALN_online_ready/app/src/main/res/layout
mkdir -p ALN_online_ready/app/src/main

# -------- Kotlin files --------
cat > ALN_online_ready/app/src/main/java/com/aln/chat/MainActivity.kt <<EOL
package com.aln.chat

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.auth.FirebaseAuth

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        if(FirebaseAuth.getInstance().currentUser == null){
            startActivity(Intent(this, LoginActivity::class.java))
            finish()
        } else {
            startActivity(Intent(this, ChatActivity::class.java))
            finish()
        }
    }
}
EOL

cat > ALN_online_ready/app/src/main/java/com/aln/chat/LoginActivity.kt <<EOL
package com.aln.chat

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.auth.FirebaseAuth

class LoginActivity : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        auth = FirebaseAuth.getInstance()
        val emailInput = findViewById<EditText>(R.id.emailInput)
        val passInput = findViewById<EditText>(R.id.passInput)
        val loginBtn = findViewById<Button>(R.id.loginBtn)

        loginBtn.setOnClickListener {
            val email = emailInput.text.toString()
            val pass = passInput.text.toString()

            auth.signInWithEmailAndPassword(email, pass).addOnCompleteListener { task ->
                if(task.isSuccessful){
                    startActivity(Intent(this, ChatActivity::class.java))
                    finish()
                } else {
                    Toast.makeText(this, "Login failed: ${task.exception?.message}", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }
}
EOL

# Repeat similar blocks for ChatActivity.kt, PasswordLockActivity.kt, CallActivity.kt
# You can copy the other Kotlin code from earlier into similar cat >> commands

# -------- Layout files --------
cat > ALN_online_ready/app/src/main/res/layout/activity_main.xml <<EOL
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <TextView
        android:id="@+id/welcomeText"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Welcome to ALN!" />
</LinearLayout>
EOL

cat > ALN_online_ready/app/src/main/AndroidManifest.xml <<EOL
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.aln.chat">

    <application
        android:allowBackup="true"
        android:label="ALN"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.ALN">

        <activity android:name="com.aln.chat.PasswordLockActivity" />
        <activity android:name="com.aln.chat.LoginActivity" />
        <activity android:name="com.aln.chat.ChatActivity" />
        <activity android:name="com.aln.chat.CallActivity" />
        <activity android:name="com.aln.chat.MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOL

echo "All files created successfully!"
echo "Now compress folder: zip -r ALN_online_ready.zip ALN_online_ready"
