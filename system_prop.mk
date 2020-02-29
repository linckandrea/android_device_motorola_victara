# Audio
PRODUCT_PROPERTY_OVERRIDES += \
af.fast_track_multiplier=1
	vendor.audio_hal.period_size=192
	persist.vendor.audio.fluence.speaker=false
	persist.vendor.audio.fluence.voicecall=true
	persist.vendor.audio.fluence.voicerec=false
	ro.config.vc_call_vol_steps=7
	ro.vendor.audio.sdk.fluencetype=fluence
	vendor.voice.path.for.pcm.voip=true
	ro.config.media_vol_steps=25
	ro.config.vc_call_vol_steps=7

# Acdb
PRODUCT_PROPERTY_OVERRIDES += \
	persist.audio.calfile0=/vendor/etc/acdbdata/Bluetooth_cal.acdb
	persist.audio.calfile1=/vendor/etc/acdbdata/General_cal.acdb
	persist.audio.calfile2=/vendor/etc/acdbdata/Global_cal.acdb
	persist.audio.calfile3=/vendor/etc/acdbdata/Handset_cal.acdb
	persist.audio.calfile4=/vendor/etc/acdbdata/Hdmi_cal.acdb
	persist.audio.calfile5=/vendor/etc/acdbdata/Headset_cal.acdb
	persist.audio.calfile6=/vendor/etc/acdbdata/Speaker_cal.acdb

# FM maximum volume be between 0 and 8192 (0dB)
PRODUCT_PROPERTY_OVERRIDES += \
	ro.audio.fm_max_volume=5793

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
	qcom.bluetooth.soc=smd

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
	debug.stagefright.ccodec=0
	camera2.portability.force_api=1

# GPS
PRODUCT_PROPERTY_OVERRIDES += \
	persist.mot.gps.smart_battery=1

# Graphics
PRODUCT_PROPERTY_OVERRIDES += \
	persist.hwc.mdpcomp.enable=true
	ro.hdmi.enable=true
	ro.opengles.version=196608
	ro.qualcomm.cabl=0
	ro.sf.lcd_density=480
	debug.hwui.use_buffer_age=false
	debug.stagefright.omx_default_rank.sw-audio=1
	debug.stagefright.omx_default_rank=0
        debug.sf.latch_unsignaled=1 \
	debug.sf.enable_gl_backpressure=1 \
	persist.media.treble_omx=false

# QCOM
PRODUCT_PROPERTY_OVERRIDES += \
	ro.vendor.extension_library=/vendor/lib/libqc-opt.so

# RIL
PRODUCT_PROPERTY_OVERRIDES += \
	DEVICE_PROVISIONED=1
	persist.data.netmgrd.qos.enable=true
	persist.data.qmi.adb_logmask=0
	persist.qcril_uim_vcc_feature=1
	persist.radio.apm_sim_not_pwdn=1
	persist.radio.apn_delay=5000
	persist.radio.dfr_mode_set=1
	persist.radio.msgtunnel.start=false
	persist.radio.nitz_lons_0=
	persist.radio.nitz_lons_1=
	persist.radio.nitz_lons_2=
	persist.radio.nitz_lons_3=
	persist.radio.nitz_plmn=
	persist.radio.nitz_sons_0=
	persist.radio.nitz_sons_1=
	persist.radio.nitz_sons_2=
	persist.radio.nitz_sons_3=
	persist.radio.no_wait_for_card=1
	persist.radio.add_power_save=1
	persist.radio.oem_ind_to_both=false
	persist.radio.relay_oprt_change=1
	rild.libargs=-d /dev/smd0
	rild.libpath=/vendor/lib/libril-qc-qmi-1.so
	ril.subscription.types=NV,RUIM
	ro.data.large_tcp_window_size=true
	ro.use_data_netmgrd=true

# Time services
PRODUCT_PROPERTY_OVERRIDES += \
	persist.timed.enable=true

# Wifi
PRODUCT_PROPERTY_OVERRIDES += \
	ro.disableWifiApFirmwareReload=true

# Other
# Motorola's init sets this, let's just do it ourselves
PRODUCT_PROPERTY_OVERRIDES += \
	ro.hw.device=victara
# Play store
PRODUCT_PROPERTY_OVERRIDES += \
	ro.com.google.clientidbase.gmm=android-motorola