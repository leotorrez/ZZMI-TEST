struct u0_t
{
    float3 pos;
    float3 norm;
    float4 tang;
};
struct shapekey_t
{
    uint idx;
    float3 pos;
    float3 norm;
    float3 tang;
};
struct cb0_t
{
    uint offset;
    uint count;
    float multiplier;
    uint unused;
};
RWStructuredBuffer<u0_t> u0 : register(u0);
StructuredBuffer<shapekey_t> t0 : register(t0);
cbuffer cb0 : register(b0)
{
    cb0_t cb0[1];
}
[numthreads(64, 1, 1)]
void main(uint3 vThreadID: SV_DispatchThreadID)
{
    if (vThreadID.x >= cb0[0].count)
        return;
    int index = vThreadID.x + cb0[0].offset;
    shapekey_t shapekey = t0[index];
    u0_t u0_data = u0[shapekey.idx];
    // u0_data.pos = shapekey.pos * cb0[0].multiplier + u0_data.pos;
    // u0_data.norm = shapekey.norm * cb0[0].multiplier + u0_data.norm;
    // u0_data.tang.xyz = shapekey.tang * cb0[0].multiplier + u0_data.tang.xyz;
    u0_data.pos = 666;
    u0_data.norm = 777;
    u0_data.tang.xyzw = 888;
    u0[shapekey.idx] = u0_data;
}
