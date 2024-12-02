import { NextResponse } from 'next/server';

export async function PATCH(): Promise<NextResponse> {
  console.log('api firewall route.ts is running ========>');

  // Check if we're in production
  if (process.env.VERCEL_ENV !== 'production') {
    return NextResponse.json({ status: 'Skipped: Not in production' }, { status: 200 });
  }

  const baseUrl = 'https://api.vercel.com/v1/security/firewall/config';

  const body = JSON.stringify({
    action: 'rules.insert',
    id: null,
    value: {
      active: true,
      name: 'Deny non-browser traffic or blacklisted ASN',
      description: 'Deny traffic without Mozilla or from a specific ASN',
      conditionGroup: [
        {
          conditions: [
            {
              neg: true,
              op: "re",
              type: 'user_agent',
              value: '.*Mozilla.*',
            },
          ],
        },
        {
          conditions: [
            {
              op: 'inc',
              type: 'geo_as_number',
              value: ["124", "456", "789"],
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

  try {
    const res = await fetch(`${baseUrl}?projectId=${process.env.VERCEL_PROJECT_ID}&teamId=${process.env.VERCEL_TEAM_ID}`, {
      method: 'PATCH',
      headers: {
        Authorization: `Bearer ${process.env.VERCEL_TOKEN}`,
        'Content-Type': 'application/json',
      },
      body,
    });

    if (!res.ok) {
      const errorData = await res.json();
      console.error('Failed to update Firewall:', errorData);
      return NextResponse.json(
        { status: 'Failed to update Firewall', error: errorData },
        { status: res.status }
      );
    }

    return NextResponse.json({ status: 'New rule added to Firewall' });
  } catch (error) {
    console.error('Error updating Firewall:', error);
    return NextResponse.json(
      { status: 'Error updating Firewall', error: String(error) },
      { status: 500 }
    );
  }
}

