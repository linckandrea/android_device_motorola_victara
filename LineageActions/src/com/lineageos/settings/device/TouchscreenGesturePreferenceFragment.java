/*
 * Copyright (C) 2015 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.lineageos.settings.device;

import android.app.ActionBar;
import android.os.Bundle;
import android.view.MenuItem;
import androidx.preference.PreferenceCategory;
import androidx.preference.PreferenceFragment;

public class TouchscreenGesturePreferenceFragment extends PreferenceFragment {
    private static final String CATEGORY_AMBIENT_DISPLAY = "ambient_display_key";

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.gesture_panel);
        final ActionBar actionBar = getActivity().getActionBar();
        actionBar.setDisplayHomeAsUpEnabled(true);
        PreferenceCategory ambientDisplayCat = (PreferenceCategory)
                findPreference(CATEGORY_AMBIENT_DISPLAY);
        if (ambientDisplayCat != null) {
            ambientDisplayCat.setEnabled(LineageActionsSettings.isDozeEnabled(getActivity().getContentResolver()));
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            getActivity().onBackPressed();
            return true;
        }
        return false;
    }
}
