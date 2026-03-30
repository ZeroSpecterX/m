# m#!/bin/bash

# - بك ---
TRAFF_TOKEN="DpTUbDofl+qpSdMLpKrIFtdM25ulx6MdVVvKvV7jFrI="
REPOCKET_API="b5b1d57e-6476-463c-9576-0a954d07e64f"

echo "🚀 [$(date +%T)] جاري تشغيل محركات الأرباح على سيرفر ألمانيا..."
echo "--------------------------------------------------------"

# مصفوفة لتتبع الحالة
declare -A status

# وظيفة للفحص والتشغيل
run_engine() {
    local name=$1
    local command=$2
    
    echo -n "⏳ جاري تشغيل $name... "
    if eval "$command" > /dev/null 2>&1; then
        echo "✅ [نجاح]"
        status[$name]="WORKING"
    else
        echo "❌ [فشل]"
        status[$name]="FAILED"
    fi
}

# 1. محرك Traffmonetizer
run_engine "Traffmonetizer" "docker run -d --name tm-engine --restart always traffmonetizer/cli_v2 start accept --token '$TRAFF_TOKEN'"

# 2. محرك Repocket
run_engine "Repocket" "docker run -d --name rp-engine --restart always -e RP_API_KEY='$REPOCKET_API' repocket/repocket"

# 3. محرك EarnApp
run_engine "EarnApp" "docker run -d --name ea-engine --restart always earnapp/earnapp"

echo "--------------------------------------------------------"
echo "📊 ملخص الحالة النهائية:"
for engine in "${!status[@]}"; do
    echo "🔹 $engine: ${status[$engine]}"
done
echo "--------------------------------------------------------"

# استخراج رابط EarnApp تلقائياً (ينتظر 5 ثوانٍ لتوليد الرابط)
echo "🔍 جاري استخراج رابط ربط EarnApp..."
sleep 5
EARN_LINK=$(docker logs ea-engine 2>&1 | grep -o 'https://earnapp.com/i/[a-zA-Z0-9]*' | tail -n 1)

if [ ! -z "$EARN_LINK" ]; then
    echo "📎 رابط الربط الخاص بك: $EARN_LINK"
else
    echo "⚠️ لم يظهر رابط EarnApp بعد، استخدم: 'docker logs ea-engine' لاحقاً."
fi
echo "--------------------------------------------------------"
