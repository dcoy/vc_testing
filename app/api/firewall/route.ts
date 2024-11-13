export async function PATCH() {
  console.log('api firewall route.js is running ========>')
  const baseUrl = 'https://api.vercel.com/v1/security/firewall/config';
 
  const body = JSON.stringify({
    action: 'rules.insert',
    id: null,
    value: {
      active:
        true /** Whether this rule is enabled or not in your Vercel WAF configuration */,
      name: 'Deny non-browser traffic or blacklisted ASN',
      description: 'Deny traffic without Mozilla or from a specific ASN',
      conditionGroup: [ /** Any of the conditions in this array can be true */
        {
          conditions: [
            {
              neg: true, /** Perform negative match */
              op: "re", /** Operator used to compare - re equivalent to "Match regex expression" */
              type: 'user_agent' /** Parameter from incoming traffic */,
              value: '.*Mozilla.*',
            },
          ],
        },
        {
          conditions: [
            {
              op: 'inc' /** Operator used to compare - inc equivalent to "Includes"*/,
              type: 'geo_as_number' /** Parameter from incoming traffic */,
              value: ["124", "456", "789"], /** includes any of the number combinations in the array */
            },
          ],
        },
      ],
      action: {
        mitigate: {
          action: 'deny',
          rateLimit: null,
          redirect: null,
          actionDuration: null,
        },
      },
    },
  });
 
  const res = await fetch(`${baseUrl}?projectId=${process.env.VERCEL_PROJECT_ID}&teamId=${process.env.VERCEL_TEAM_ID}`, {
    method: 'PATCH',
    headers: {
      Authorization: `Bearer ${process.env.VERCEL_TOKEN}`,
      'Content-Type': 'application/json',
    },
    body,
  });
 
  if (!res.ok) {
    return Response.json(
      { status: 'Failed to update Firewall' },
      { status: res.status },
    );
  }
 
  return Response.json({ status: 'New rule added to Firewall' });
}